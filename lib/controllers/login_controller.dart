import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Instanciamos firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  // creamos las variables para capturar la info de los texfield
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ponemos async porque esperaremos la respuesta del server
  // await sera el que esperara esa resp y seguira con el proceso
  void loginEmailPassword() async {
    // usamos un control de errores
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text))
          .user;
      // mostramos un aviso una ves se aya logeado
      Get.snackbar(
        'Bienvenido a Speed', //titulo
        'Su ingreso fue exitoso',
      );
      print('Login correcto');
      // hacemos un delay de 2 s y que acceda a la vista
      Future.delayed(
        Duration(seconds: 2),
        () => Get.toNamed('/home'),
      );
    } catch (e) {
      // si fallo mostramos el aviso abajo
      Get.snackbar(
        'Error',
        'Datos incorrectos, no se ha podido ingresar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _signOut() async {
    await _auth.signOut();
  }

  // cierre de sesion con aviso
  void cerrarSesion() async {
    // preguntamos si hay una cuenta iniciada
    final User user = await _auth.currentUser;
    // si esto esta vacio avisamos
    if (user != null) {
      _signOut();
      final String uid = user.uid;
      Get.snackbar(
        'Sesión finalizada',
        'Se ha cerradi sesión exitosamente',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.toNamed('/SelectRol');
    }
    Get.snackbar(
      'Fallo',
      'No hay ninguna cuenta iniciada',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }
}
