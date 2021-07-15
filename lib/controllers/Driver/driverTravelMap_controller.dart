import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:speed/Models/client.dart';
import 'package:speed/Models/prices.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/Models/travelInfo.dart';
import 'package:speed/api/environment.dart';
import 'package:speed/components/bottomSheetDriver.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Providers/geoFlutter_controller.dart';
import 'package:speed/controllers/Providers/prices_provider.dart';
import 'package:speed/controllers/Providers/travelHistory_provider.dart';
import 'package:speed/controllers/Providers/travelInfo_provider.dart';
import 'package:speed/screen/Driver/driverTravelCalificaction_screen.dart';
import 'package:speed/theme/themeChange.dart';
import 'package:speed/utils/snackBar.dart';

class DriverTravelMapController extends GetxController {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;
  String idTravel;

  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  // variables para la distancia hacia el lugar de recogida
  double distanceBeetween;

  // variables para distancia y tiempo del viaje
  Timer _timer;
  int seconds = 0;
  int minuto = 0;
  double metros = 0;
  double km = 0;

  @override
  void onInit() {
    super.onInit();
    idTravel = Get.arguments as String;
    print('idddddddd $idTravel');
  }

  @override
  void onReady() async {
    super.onReady();
    loadStyle();
    markerDriver = await createMarkerImage('assets/images/pinAuto.png');
    fromMarker = await createMarkerImage('assets/images/pinInicio.png');
    toMarker = await createMarkerImage('assets/images/pinLlegada.png');
    checkGPS();

    // animatePosition();
    // respuestita();
  }

  @override
  void dispose() {
    super.dispose();
    _streamPosition?.cancel();
    _timer?.cancel();
  }

  // variables para TR
  Position _position;
  StreamSubscription<Position> _streamPosition;

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

  TravelInfo travelInfo;

  String curretStatus = 'Iniciar Viaje';
  Color colorStatus = Color(0XFFE7D42F);

  Client client;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 17,
  );

  void onMapCreate(GoogleMapController controller) async {
    _mapController.complete(controller);
    setMapStyle();
    // await setPolylines();
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

  Future volver() async {
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
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool forzeGPS = await location.Location().requestService();
      if (forzeGPS) {
        updateLocation();
      } else {
        snackError(
          title: 'Error GPS',
          msg: 'Debe hablitar el GPS para usar los servicios',
        );
      }
    }
  }

  void updateLocation() async {
    try {
      // accedemos a la localizacion del telefono
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      _getTravelInfo();
      centrarPosition();
      // Guardado de ubi en firestore
      saveLocation();
      addMarker(
        'driver',
        _position.latitude,
        _position.longitude,
        'Tu ubicación',
        '',
        markerDriver,
      );
      update();

      _streamPosition = Geolocator.getPositionStream(
        // desiredAccuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ).listen((Position position) {
        if (travelInfo?.status == 'started') {
          // la distancia se calculara desde el punto de partida
          //hasta el punto q ira avanzando el conductor
          metros = metros +
              Geolocator.distanceBetween(
                _position.latitude,
                _position.longitude,
                position.latitude,
                position.longitude,
              );
          km = metros / 1000;
          // km = km.toPrecision(1);
        }

        _position = position;
        addMarker(
          'driver',
          _position.latitude,
          _position.longitude,
          'Tu ubicación',
          '',
          markerDriver,
        );
        animatePosition(_position.latitude, _position.longitude);
        // Guardado de ubi en firestore
        // preguntamos si ya tenemos los valores del travelinfo
        if (travelInfo.fromLat != null && travelInfo.fromLng != null) {
          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
          isClosePickupPosition(from, to);
        }
        saveLocation();
        update();
      });
    } catch (e) {
      print('Error en la localizacion : $e');
    }
  }

  void centrarPosition() {
    if (_position != null) {
      animatePosition(_position.latitude, _position.longitude);
    } else {
      snackError(
        title: 'Error',
        msg: 'Activa el GPS para obtener su ubicación',
      );
    }
  }

  Future animatePosition(double lat, double log) async {
    final controller = await _mapController.future;
    if (_position != null) {
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
  }

  // Solicita los permisos y los accesos a la localizacion del telefono
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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

  // funcion para añadir marcador
  void addMarker(
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

      // configuracion para la animacion del marker
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      rotation: _position.heading,
    );

    markers[id] = marker;
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

  void saveLocation() async {
    await Geoflutter()
        .createWorking(getUser().uid, _position.latitude, _position.longitude);
  }

  // obtener la info del viaje
  void _getTravelInfo() async {
    travelInfo = await TravelInfoProvider().getById(idTravel);
    LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
    LatLng from = new LatLng(_position.latitude, _position.longitude);
    addSimpleMarker('from', to.latitude, to.longitude, 'Recoger aqui',
        travelInfo.from, fromMarker);
    await setPolylines(from, to);
    getCliente();
  }

  // funciones de cambiado de estado
  void updateStatus() {
    if (travelInfo.status == 'accepted') {
      startTravel();
    } else if (travelInfo.status == 'started') {
      finishTravel();
    }
  }

  void startTravel() async {
    if (distanceBeetween <= 100) {
      Map<String, dynamic> data = {
        'status': 'started',
      };
      await TravelInfoProvider().actualizar(data, idTravel);
      travelInfo.status = 'started';
      curretStatus = 'Finalizar Viaje';
      colorStatus = Colors.grey[200];

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
      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);
      setPolylines(from, to);
      // contador de tiempo
      startTimer();
      update();
    } else {
      snackError(
        title: 'Distancia extensa',
        msg:
            'Debes estar cerca a la posicion del cliente para poder iniciar el viaje',
      );
    }

    update();
  }

  void finishTravel() async {
    _timer?.cancel();
    // double total = await calcularPrice();

    saveTravelHistory();

    update();
  }

  void saveTravelHistory() async {
    TravelHistory travelHistory = TravelHistory(
      from: travelInfo.from,
      to: travelInfo.to,
      idDriver: getUser().uid,
      idClient: idTravel,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      price: travelInfo.price,
    );
    String id = await TravelHistoryProvider().create(travelHistory);
    // obtenemos el id del travel history y lo pasamos a la calificacion

    // Actualizamos la bd con el id del history para enviarlo al cliente
    Map<String, dynamic> data = {
      'status': 'finished',
      'idTravelHistory': id,
    };
    await TravelInfoProvider().actualizar(data, idTravel);
    travelInfo.status = 'finished';
    Get.offAll(
      () => DriverTravelCalification(),
      transition: Transition.downToUp,
      arguments: id,
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

  // Funcion para saber la distancia cercana
  void isClosePickupPosition(LatLng from, LatLng to) {
    distanceBeetween = Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
    print('Distancia $distanceBeetween');
  }

  // metodo para el tiempo y distancia
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // obtendra la suma de uno en uno
      seconds++;
      if (seconds % 60 == 0) {
        seconds = 0;
        minuto++;
      }
      // minuto = minuto.toPrecision(2);
      update();
    });
  }

  // calcular precio
  Future<double> calcularPrice() async {
    Prices prices = await PricesProvider().getAll();

    if (seconds < 60) seconds = 60;
    if (km == 0) km = 0.1;
    // la division nos da un entero
    int min = seconds ~/ 60;
    print('------- Min Totales---------');
    print(min.toString());
    print('------- km Totales---------');
    print(km.toString());

    double priceMin = min * prices.min;
    double priceKm = km * prices.km;
    double total = priceKm + priceMin;
    if (total < prices.minValue) total = prices.minValue;

    return total;
  }

  // obtenemos info del cliente
  void getCliente() async {
    client = await ClientController().getById(idTravel);
    update();
  }

  // abrir informacion del conductor
  void openBottomSheet(context) {
    if (client == null) return;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomSheetDriver(
        url: client?.image,
        nombre: client?.username,
        correo: client?.email,
      ),
    );
  }
}
