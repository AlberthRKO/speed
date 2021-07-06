import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Providers/geoFlutter_controller.dart';
import 'package:speed/theme/themeChange.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speed/utils/snackBar.dart';

class ClientMapController extends GetxController {
  // StreamSubscription<DocumentSnapshot> _statusSubcription;
  StreamSubscription<DocumentSnapshot> _clientInfoSubcription;

  /* @override
  void onInit() async {
    super.onInit();
    loadStyle();
    markerDriver = await createMarkerImage('assets/images/pinAuto.png');
    checkGPS();
  } */

  @override
  void onReady() async {
    super.onReady();
    loadStyle();
    markerDriver = await createMarkerImage('assets/images/pinAutos.png');
    checkGPS();
    getUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    // _streamPosition?.cancel();
    // _statusSubcription?.cancel();
    _clientInfoSubcription?.cancel();
  }

  final formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;

  // variables para TR
  Position _position;
  // StreamSubscription<Position> _streamPosition;

  // Variables para marcadores
  // lista de marcadores
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor markerDriver;

  //variables para guardar posicion
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // variable para guardado de conductor
  bool isConnect = false;

  //info del usuario
  Driver driver;
  Client client;

  User getUser() {
    return _auth.currentUser;
  }

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 17,
  );

  void onMapCreate(GoogleMapController controller) {
    _mapController.complete(controller);
    setMapStyle();
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

  /* --------------------
    Seccion de Mapa TR
  ---------------------- */

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool forzeGPS = await Location().requestService();
      if (forzeGPS) {
        updateLocation();
      } else {
        snackError(
          title: 'Error',
          msg: 'Debe hablitar el GPS para usar los servicios',
        );
      }
    }
  }

  void updateLocation() async {
    try {
      // accedemos a la localizacion del telefono
      await _determinePosition();
      // solo una vez
      _position = await Geolocator.getLastKnownPosition();
      centrarPosition();
      nearbyDriver();
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

      /* // configuracion para la animacion del marker
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      rotation: _position.heading, */
    );

    markers[id] = marker;
  }

  /* -----------------
  Seccion de info de usuario
  ----------------- */
  void getUserInfo() {
    Stream<DocumentSnapshot> clientStream =
        ClientController().getByIdstream(getUser().uid);
    _clientInfoSubcription = clientStream.listen(
      (DocumentSnapshot document) {
        client = Client.fromJson(
          document.data(),
        );
        update();
      },
    );
  }

  /* --------------------
  Seccion de mostrar conductores cercanos
  ---------------------- */
  // le mandamos la ultima posicion y el radio de busqueda de drivers
  void nearbyDriver() {
    Stream<List<DocumentSnapshot>> stream = Geoflutter()
        .getNearbyDriver(_position.latitude, _position.longitude, 2);
    stream.listen((List<DocumentSnapshot> documentList) {
      for (MarkerId m in markers.keys) {
        bool remove = true;
        for (DocumentSnapshot d in documentList) {
          if (m.value == d.id) {
            remove = false;
          }
        }
        if (remove) {
          markers.remove(m);
          update();
        }
      }
      for (DocumentSnapshot d in documentList) {
        GeoPoint point = d.data()['position']['geopoint'];
        addMarker(
          d.id,
          point.latitude,
          point.longitude,
          'Conductor Disponible',
          '',
          markerDriver,
        );
      }
      update();
    });
  }
}
