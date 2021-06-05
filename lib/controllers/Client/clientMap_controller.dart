import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/theme/themeChange.dart';

class ClientMapController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _loadMapStyles();
  }

  final formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;

  // posicion inicial de la camara
  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 14.0,
  );

  // creacion del mapa resibiendo estilo en base a isDark
  void onMapCreate(GoogleMapController controller) {
    _mapController.complete(controller);
    setMapStyle();
    /* controller.setMapStyle(
        TemaProvider().isDark ? TypeMap().mapDark() : TypeMap().mapLight()); */
  }

  //manda al punto inicial de la ubicacion
  Future<void> volver() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initialPosition));
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
}
