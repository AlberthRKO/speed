import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:speed/screen/Client/clientRegister_screen.dart';
import 'package:speed/screen/Driver/driverRegister_screen.dart';
import 'package:speed/screen/home_screen.dart';
import 'package:speed/screen/select_page.dart';
import 'package:speed/utils/progress.dart';

class LoginController extends GetxController {
  // Instanciamos firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final appData = GetStorage();

  final formKey = GlobalKey<FormState>();

  // creamos las variables para capturar la info de los texfield
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void mostrar() {
    print(emailController.text + '\n' + passwordController.text);
  }

  void dispose() {
    // limpiamos los campos
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String tipeUser() {
    String tipo = appData.read('typeUser');
    if (tipo == 'Client') {
      return 'pasajero';
    }
    return 'conductor';
  }

  void goRegister() {
    String tipo = appData.read('typeUser');
    if (tipo == 'Client')
      Get.to(
        () => ClientRegister(),
        transition: Transition.size,
      );
    else
      Get.to(
        () => DriverRegister(),
        transition: Transition.size,
      );
  }

  // ponemos async porque esperaremos la respuesta del server
  // await sera el que esperara esa resp y seguira con el proceso
  Future<void> loginEmailPassword(context) async {
    ProgressDialog pr =
        Progresso.crearProgress(context, 'Espere un momento...');
    // String email = emailController.text;
    // String pass = passwordController.text;

    /* if (email.isEmpty && pass.isEmpty) {
      snackError(
        title: 'Error',
        msg: 'Los campos no pueden estar vacios',
      );
      return;
    }
    if (!GetUtils.isEmail(email)) {
      snackError(
        title: 'Error',
        msg: 'Formato de email invalido',
      );
      return;
    }

    if (pass.length <= 6) {
      snackError(
        title: 'Error',
        msg: 'La contraseña debe tener almenos 6 caracteres',
      );
      return;
    } */
    if (formKey.currentState.validate()) {
      print('Formulario valido');
    } else {
      print('Formulario invalido');
      return;
    }

    pr.show();
    // usamos un control de errores
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ))
          .user;

      String name = emailController.text;
      pr.hide();
      // mostramos un aviso una ves se aya logeado
      Get.snackbar(
        'Bienvenido a Speed', //titulo
        'Su cuenta $name, ingreso correctamente',
        backgroundColor: Theme.of(context).cardColor,
        colorText: Theme.of(context).hintColor,
      );
      print('Login correcto');
      // hacemos un delay de 2 s y que acceda a la vista
      Future.delayed(
        Duration(seconds: 2),
        () => Get.to(
          () => Home(),
          transition: Transition.upToDown,
        ),
      );
    } catch (e) {
      print(e);
      // si fallo mostramos el aviso abajo
      pr.hide();
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        colorText: Theme.of(context).hintColor,
      );
    }
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
          () => SelectRol(),
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

  void snackError({@required title, @required msg}) {
    return Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[400],
    );
  }
}
