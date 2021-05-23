import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  bool isDrawerOpen = false;
  double xOffset = 0;
  double yOffset = 0;

  void abrirSidebar(Size size) {
    if (isDrawerOpen) {
      xOffset = 0;
      yOffset = 0;
      isDrawerOpen = false;
    } else {
      // si es true hacemos que se recorra para la deracha restando del resto del ancho
      // y hacia abajo en base a su division del resto del alto
      xOffset = size.width - 150;
      yOffset = size.height / 7;
      isDrawerOpen = true;
    }
    print(isDrawerOpen);
    update();
  }
}
