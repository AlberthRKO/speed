import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/theme/themeChange.dart';

class DriverMapController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadStyle();
  }

  final formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 15.0,
  );

  void onMapCreate(GoogleMapController controller) {
    _mapController.complete(controller);
    setMapStyle();
  }

  void volver() async {
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initialPosition));
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
}
