import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:speed/screen/Client/clientRegister_screen.dart';
import 'package:speed/screen/Driver/driverRegister_screen.dart';
import 'package:speed/screen/Client/home_screen.dart';
import 'package:speed/screen/Driver/homeDriver_screen.dart';
import 'package:speed/utils/progress.dart';

class LoginController extends GetxController {
  // Instanciamos firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User> status;
  final appData = GetStorage();

  final formKey = GlobalKey<FormState>();

  // creamos las variables para capturar la info de los texfield
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get tipo => appData.read('typeUser');

  void mostrar() {
    print(emailController.text + '\n' + passwordController.text);
  }

  void dispose() {
    // limpiamos los campos
    emailController.dispose();
    passwordController.dispose();
    status?.cancel();
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

  void isLogin() {
    String notifi = appData.read('isNotification');
    status = FirebaseAuth.instance.authStateChanges().listen(
      (User user) {
        if (user != null) {
          print('validacionnnnnn $notifi');
          // sii entramos a la notificacion..no hace nada
          print('Usuario logeado');
          if (tipo == 'Client')
            Get.off(() => Home());
          else if (tipo == 'Driver') {
            Get.off(() => HomeDriver());
          }
        } else {
          print('Usuario no logeado');
        }
      },
    );
  }

  void _signOut() async {
    await _auth.signOut();
  }

  // PAra averiguar si el usuario es driver o client preguntaremos
  //si su uid existe en la coleccion

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
    }**/
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
      // String name = emailController.text;
      // preguntamos si ubo login
      if (user != null) {
        pr.hide();
        // si es de tipo client obtenemos el modelo en base al uid del login
        if (tipo == 'Client') {
          Client client = await ClientController().getById(user.uid);
          if (client != null) {
            String nombre = client.username;
            Get.snackbar(
              'Bienvenido a Speed', //titulo
              'Su cuenta $nombre como ' +
                  tipeUser() +
                  ', ingreso correctamente',
              backgroundColor: Theme.of(context).cardColor,
              // icon: Icon(FontAwesomeIcons.solidLaughWink),
              colorText: Theme.of(context).hintColor,
            );
            print('Login correcto');
            // hacemos un delay de 2 s y que acceda a la vista
            Future.delayed(
              Duration(seconds: 2),
              () {
                Get.offAll(
                  () => Home(),
                  transition: Transition.upToDown,
                );
              },
            );
            // si no pillamos el modelo es xq n fue client el del login
            //y n se lo encontro en la db
          } else {
            snackError(title: 'Error', msg: 'El acceso no es valido');
            _signOut();
            return;
          }
        } else if (tipo == 'Driver') {
          Driver driver = await DriverController().getById(user.uid);
          if (driver != null) {
            String nombre = driver.username;
            if (driver.estado == 'pendiente') {
              Get.snackbar(
                'Cuenta Pendiente', //titulo
                'Su cuenta $nombre como ' +
                    tipeUser() +
                    ', esta en revision y aun no se valido su acceso',
                backgroundColor: Theme.of(context).cardColor,
                // icon: Icon(FontAwesomeIcons.solidLaughWink),
                colorText: Theme.of(context).hintColor,
              );
              _signOut();
              return;
            }
            if (driver.estado == 'rechazado') {
              snackError(
                  title: 'Cuenta Rechazada',
                  msg: 'Su cuenta ha sido rechazada en la validación');
              _signOut();
              return;
            }
            if (driver.estado == 'suspendido') {
              snackError(
                  title: 'Cuenta Suspendida',
                  msg:
                      'Su cuenta ha sido suspendida debido a quejas o demandas de los clientes');
              _signOut();
              return;
            }
            if (driver.estado == 'habilitado') {
              Get.snackbar(
                'Bienvenido a Speed', //titulo
                'Su cuenta $nombre como ' +
                    tipeUser() +
                    ', ingreso correctamente',
                backgroundColor: Theme.of(context).cardColor,
                // icon: Icon(FontAwesomeIcons.solidLaughWink),
                colorText: Theme.of(context).hintColor,
              );
              print('Login correcto driver');
              // hacemos un delay de 2 s y que acceda a la vista
              Future.delayed(
                Duration(seconds: 2),
                () {
                  Get.offAll(
                    () => HomeDriver(),
                    transition: Transition.downToUp,
                  );
                },
              );
            }
          } else {
            snackError(title: 'Error', msg: 'El acceso no es valido');
            _signOut();
            return;
          }
        }
      } else {
        print('Hubo un error de login');
        pr.hide();
        snackError(
          title: 'Error',
          msg: 'Hubo un error de login',
        );
      }
      // mostramos un aviso una ves se aya logeado

    } catch (e) {
      print(e);
      // si fallo mostramos el aviso abajo
      pr.hide();
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        // icon: Icon(FontAwesomeIcons.exclamation),
        backgroundColor: Theme.of(context).cardColor,
        colorText: Theme.of(context).hintColor,
      );
    }
  }

  void snackError({@required title, @required msg}) {
    return Get.snackbar(
      title,
      msg,
      // icon: Icon(FontAwesomeIcons.exclamation),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red[400],
    );
  }
}
