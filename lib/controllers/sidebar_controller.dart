import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed/screen/select_page.dart';

class SidebarController extends GetxController {
  bool isDrawerOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;

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
    // print(isDrawerOpen);
    update();
  }

  void _signOut() async {
    await _auth.signOut();
  }

  // cierre de sesion con aviso
  void cerrarSesion(context) {
    // preguntamos si hay una cuenta iniciada
    final User user = _auth.currentUser;
    // si esto no esta vacio avisamos
    if (user != null) {
      _signOut();
      // final String uid = user.uid;
      Get.snackbar(
        'Sesión finalizada',
        'Se ha cerrado sesión exitosamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        colorText: Theme.of(context).hintColor,
      );
      Future.delayed(
        Duration(seconds: 2),
        () => Get.offAll(
          () => SelectUSer(),
          transition: Transition.zoom,
        ),
      );
    } else {
      Get.snackbar(
        'Fallo',
        'No hay ninguna cuenta iniciada',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        colorText: Theme.of(context).hintColor,
      );
    }
    return;
  }
}
