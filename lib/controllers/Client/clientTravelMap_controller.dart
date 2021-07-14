import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:speed/Models/driver.dart';
import 'package:speed/Models/travelInfo.dart';
import 'package:speed/api/environment.dart';
import 'package:speed/components/bottomSheet.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:speed/controllers/Providers/geoFlutter_controller.dart';
import 'package:speed/controllers/Providers/travelInfo_provider.dart';
import 'package:speed/theme/themeChange.dart';
import 'package:speed/utils/snackBar.dart';

class ClientTravelMapController extends GetxController {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;

  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  Driver driver;
  LatLng _driverLatLng;
  TravelInfo travelInfo;

  bool isRouteReady = false;

  String curretStatus = '';

  StreamSubscription<DocumentSnapshot<Object>> _stream;

  // variable para no trazar mas rutas
  bool isPickupTravel = false;
  bool isStartTravel = false;

  StreamSubscription<DocumentSnapshot<Object>> streamStatus;

  @override
  void onReady() async {
    super.onReady();
    loadStyle();
    markerDriver = await createMarkerImage('assets/images/pinAutos.png');
    fromMarker = await createMarkerImage('assets/images/pinInicio.png');
    toMarker = await createMarkerImage('assets/images/pinLlegada.png');
    checkGPS();
  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
    streamStatus?.cancel();
  }

  //variables para guardar posicion
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User getUser() {
    return _auth.currentUser;
  }

  // Variables para marcadores
  // lista de marcadores
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor markerDriver;

  // Variables de trazado de ruta info
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 17,
  );

  void onMapCreate(GoogleMapController controller) async {
    _mapController.complete(controller);
    setMapStyle();
    _getTravelInfo();
  }

  Future loadStyle() async {
    _darkMap = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMap = await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future setMapStyle() async {
    final controller = await _mapController.future;
    if (TemaProvider().isDark) {
      controller.setMapStyle(_darkMap);
    } else {
      controller.setMapStyle(_lightMap);
    }
  }

  /* Future volver() async {
    final controller = await _mapController.future;
    if (_position != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(_position.latitude, _position.longitude),
            zoom: 17,
          ),
        ),
      );
    }
  } */

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS activo');
    } else {
      bool forzeGPS = await location.Location().requestService();
      if (forzeGPS) {
        print('Activo el GPS');
      } else {
        snackError(
          title: 'Error GPS',
          msg: 'Debe hablitar el GPS para usar los servicios',
        );
      }
    }
  }

  /* void centrarPosition() {
    if (_position != null) {
      animatePosition(_position.latitude, _position.longitude);
    } else {
      snackError(
        title: 'Error',
        msg: 'Activa el GPS para obtener su ubicación',
      );
    }
  }*/

  Future animatePosition(double lat, double log) async {
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          // bearing: 0,
          target: LatLng(lat, log),
          zoom: 17,
        ),
      ),
    );
  }

  /* ----------------------
  Seccion de Custom Marker
  ----------------------- */

  // metodo para crear un marker recibira la ruta de la imagen
  Future<BitmapDescriptor> createMarkerImage(String path) async {
    // creamos una configuracion de imagen para pasarlo al bitmap
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addSimpleMarker(
    String markerId,
    double lat,
    double log,
    String title,
    String content,
    BitmapDescriptor icon,
  ) {
    // una ves creado un marquer hacemos que se añada a la lista
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: icon,
      position: LatLng(lat, log),
      infoWindow: InfoWindow(
        title: title,
        snippet: content,
      ),
    );

    markers[id] = marker;
  }

  // obtener la info del viaje
  void _getTravelInfo() async {
    travelInfo = await TravelInfoProvider().getById(getUser().uid);
    animatePosition(travelInfo.fromLat, travelInfo.fromLng);
    getDriverInfo(travelInfo.idDriver);
    getDriverLocation(travelInfo.idDriver);
  }

  // obtener el estado del viaje en TR
  void checkTravelStatus() async {
    Stream<DocumentSnapshot> stream =
        TravelInfoProvider().getByIdStrem(getUser().uid);
    streamStatus = stream.listen(
      (DocumentSnapshot document) {
        travelInfo = TravelInfo.fromJson(document.data());
        if (travelInfo.status == 'accepted') {
          curretStatus = 'Viaje Aceptado';
          pickupTravel();
        } else if (travelInfo.status == 'started') {
          curretStatus = 'Viaje Iniciado';
          startTravel();
        } else if (travelInfo.status == 'finished') {
          curretStatus = 'Viaje Finalizado';
        }
        update();
      },
    );
  }

  /* --------------------------
  Seccion de trazado de ruta
  ---------------------------*/

  Future<void> setPolylines(LatLng from, LatLng to) async {
    // definimos las coordenadas de los puntos
    PointLatLng pointFromLatLng = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointToLatLng = PointLatLng(to.latitude, to.longitude);

    // pasamos las coordenadas para que devuelva un resultado
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFromLatLng, pointToLatLng);

    // Recorremos los puntos del resultado para pintarlo
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    // definimos como sera la ruta pasandole la lista del for
    Polyline polyline = Polyline(
      polylineId: PolylineId('pol'),
      color: TemaProvider().isDark ? Color(0XFFE7D42F) : Color(0XFF3B4661),
      points: points,
      width: 3,
    );
    // lo definimos en la variable global
    polylines.add(polyline);

    /* addMarker(
        'to', toLatLng.latitude, toLatLng.longitude, 'Destino', to, toMarker); */

    update();
  }

  // Informacion del conductor

  void getDriverInfo(String id) async {
    driver = await DriverController().getById(id);
    update();
  }

  // obtener la ubi del conductor en tiempo real
  void getDriverLocation(String id) {
    Stream<DocumentSnapshot> streamLocation = Geoflutter().getLocationById(id);
    _stream = streamLocation.listen((DocumentSnapshot document) {
      GeoPoint geoPoint = document['position']['geopoint'];
      _driverLatLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      addSimpleMarker(
        'driver',
        _driverLatLng.latitude,
        _driverLatLng.longitude,
        'Tu conductor',
        '',
        markerDriver,
      );
      update();
      if (!isRouteReady) {
        isRouteReady = true;
        checkTravelStatus();
      }
    });
  }

  // metodo que se ejecutara cuando el viaje se acepte
  void pickupTravel() {
    if (!isPickupTravel) {
      isPickupTravel = true;
      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
      addSimpleMarker('from', to.latitude, to.longitude, 'Recoger aqui',
          travelInfo.from, fromMarker);
      setPolylines(from, to);
    }
  }

  void startTravel() {
    if (!isStartTravel) {
      isStartTravel = true;
      // Una vez q se acepte el viaje limpiamos el trazado anterior
      polylines = {};
      points = [];
      // markers.remove(markers['from']);
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');

      // creamos el marcador del to
      addSimpleMarker(
        'to',
        travelInfo.toLat,
        travelInfo.toLng,
        'Destino',
        travelInfo.to,
        toMarker,
      );
      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);
      setPolylines(from, to);
      update();
    }
  }

  // abrir informacion del conductor
  void openBottomSheet(context) {
    if (driver == null) return;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomSheetClient(
        nombre: driver?.username,
        correo: driver?.email,
        modelo: driver?.modelo,
        placa: driver?.placa,
      ),
    );
  }
}
