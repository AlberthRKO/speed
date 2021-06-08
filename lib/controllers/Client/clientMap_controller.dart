import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:speed/theme/themeChange.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speed/utils/snackBar.dart';

class ClientMapController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _loadMapStyles();
    checkGPS();
  }

  final key = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;

  // variables para el map TR
  Position _position;
  StreamSubscription<Position> _positionStream;

  // posicion inicial de la camara
  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 15.0,
  );

  // creacion del mapa resibiendo estilo en base a isDark
  void onMapCreate(GoogleMapController controller) {
    _mapController.complete(controller);
    setMapStyle();
    /* controller.setMapStyle(
        TemaProvider().isDark ? TypeMap().mapDark() : TypeMap().mapLight()); */
  }

  //manda al punto inicial de la ubicacion
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

  // cargamos el json de estilo para luego ponerlo en el setMapStyle
  Future _loadMapStyles() async {
    _darkMap = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMap = await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future setMapStyle() async {
    // preguntamos si esta en dark pra cargar los estilos
    final controller = await _mapController.future;
    if (TemaProvider().isDark)
      controller.setMapStyle(_darkMap);
    else
      controller.setMapStyle(_lightMap);
  }

  /* ************************************
   Seccion de Mapa para ubicacion en TR 
   *********************************** */

// actualizamos la ubicacion recibiendo la funcion de ubi en TR
  void updateLocation() async {
    try {
      await _determinePosition();
      // con esto obtendremos la ultima posicion en la que estuvimos ubicados
      _position = await Geolocator.getLastKnownPosition();
      centrarPosition();
      _positionStream = Geolocator.getPositionStream(
        // con esto tendra el mejor reconocimiento del GPS
        // desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 1,
        //logica para actualizar la ubi en TR, esto se ejecutara constantemente
      ).listen((Position position) {
        _position = position;
        animateCameraPosition(_position.latitude, _position.longitude);
      });
    } catch (e) {
      print('error en la localizacion : $e');
    }
  }

  void centrarPosition() {
    // preguntamos si recibimos la posicion
    if (_position != null) {
      // se animara la camara cada vez que se mueva el taxi,
      // centrandola cada vez que tenga la ultima posicion
      animateCameraPosition(_position.latitude, _position.longitude);
    } else {
      snackError(title: 'Error', msg: 'Activa el GPS para obtener la posicion');
    }
  }

  // Validamos
  void checkGPS() async {
    // con esto sabremos si el gps esta activado para luego mandar la ubi en TR
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnable) {
      print('GPS activado');
      updateLocation();
    } else {
      print('GPS desactivado');
      // con esto le decimos al usuario que debe activar el GPS
      bool locationGPS = await Location().requestService();
      if (locationGPS) {
        updateLocation();
        print('El user activo el GPS');
      }
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

  Future animateCameraPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (_position != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(latitude, longitude),
            zoom: 17,
          ),
        ),
      );
    }
  }
}
