import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:speed/screen/Driver/homeDriver_screen.dart';
import 'package:speed/utils/progress.dart';

class DriverRegisterController extends GetxController {
  // instanciamos auth de firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final modelo = TextEditingController();
  final placa = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  bool success;
  String userEmail;

  void mostrar() {
    print(name.text);
    print(modelo.text);
    print(placa.text);
    print(email.text);
    print(password.text);
    print(passwordConfirm.text);
  }

  void dispose() {
    // limpiamos los campos
    name.dispose();
    modelo.dispose();
    placa.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  Future<void> registrarUser(context) async {
    String nombre = name.text;
    String model = modelo.text;
    String placaa = placa.text;
    String emaill = email.text;
    String pass = password.text;
    String passCon = passwordConfirm.text;
    ProgressDialog pr =
        Progresso.crearProgress(context, 'Espere un momento...');
    // creamos el progress dialog

    /* if (nombre.isEmpty && emaill.isEmpty && pass.isEmpty && passCon.isEmpty) {
      snackError(
        title: 'Error',
        msg: 'Los campos no pueden estar vacios',
      );
      return;
    }
    if (!GetUtils.isEmail(emaill)) {
      snackError(
        title: 'Error',
        msg: 'Formato de email invalido',
      );
      return;
    } */

    if (formKey.currentState.validate()) {
      print('Formulario valido');
    } else {
      print('Formulario invalido');
      return;
    }
    if (pass != passCon) {
      snackError(
        title: 'Error',
        msg: 'Las contraseñas no coinciden',
      );
      return;
    }
    pr.show();

    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      ))
          .user;

      // preguntamos si existe usuario
      if (user != null) {
        Driver driver = new Driver(
          id: user.uid,
          username: nombre,
          modelo: model,
          placa: placaa,
          email: emaill,
          password: pass,
        );

        await DriverController().create(driver);
        pr.hide();
        Get.snackbar(
          'Registro Exitoso', //titulo
          'Su cuenta como $nombre ha sido creada',
          backgroundColor: Theme.of(context).cardColor,
          colorText: Theme.of(context).hintColor,
        );
        success = true;
        print('Registrado');
        print(user.uid);
        Future.delayed(
          Duration(seconds: 2),
          () => Get.offAll(
            () => HomeDriver(),
            transition: Transition.downToUp,
          ),
        );

        userEmail = user.email;
      }
    } catch (e) {
      print(e);
      pr.hide();
      // si fallo mostramos el aviso abajo
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).cardColor,
        colorText: Theme.of(context).hintColor,
      );
    }
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
