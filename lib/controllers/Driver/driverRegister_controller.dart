import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:speed/controllers/Providers/storage_provider.dart';
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

  PickedFile pickedFile;
  PickedFile pickedFileModelo;
  File imageFile;
  File imagenDriver;
  var selectImagePath = ''.obs;
  var selectImagePathModelo = ''.obs;
  var selectImageSize = ''.obs;

  Future<void> registrarUser(context) async {
    String nombre = name.text;
    String model = modelo.text;
    String placaa = placa.text;
    String emaill = email.text;
    String pass = password.text;
    String passCon = passwordConfirm.text;

    String imageUrl = '';
    String imageUrlModelo = '';
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
    // pr.show();
    if (pickedFile == null || pickedFileModelo == null) {
      snackError(
        title: 'Error',
        msg: 'Debe cargar todas las fotos',
      );
      return;
    } else {
      pr.show();
      TaskSnapshot snapshot = await StorageProvider().uploadFile(pickedFile);
      TaskSnapshot snapshotModelo =
          await StorageProvider().uploadFile(pickedFileModelo);
      imageUrl = await snapshot.ref.getDownloadURL();
      imageUrlModelo = await snapshotModelo.ref.getDownloadURL();
      pr.hide();
    }
    // pr.hide();

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
          image: imageUrl,
          imageModelo: imageUrlModelo,
          // image: imageUrl,
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

  /* // *Seccion de imagen registro */
/* 
  Future getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      print(imageFile.path);
      print('kheeeeee $imageFile');
      print('aqui esta $pickedFile');
    } else {
      print('No selecciono ninguna imagen');
    }
    Get.back();
    update();
  } */

  //Correcto
  Future pickImagenn(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      selectImagePath.value = pickedFile.path;
      selectImageSize.value =
          ((File(selectImagePath.value)).lengthSync() / 1024 / 1024)
                  .toStringAsFixed(2) +
              " MB";
    } else {
      print('No selecciono ninguna imagen');
    }
    Get.back();
    update();
  }

  // Elegir entre camara o foto
  void showAlertDialog(context) {
    Widget galleryButton = TextButton(
      onPressed: () {
        pickImagenn(ImageSource.gallery);
      },
      child: Text('GALERIA'),
    );
    Widget cameraButton = TextButton(
      onPressed: () {
        pickImagenn(ImageSource.camera);
      },
      child: Text('CAMARA'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(
        'Selecciona tu imagen',
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Future pickImagenModelo(ImageSource imageSource) async {
    pickedFileModelo = await ImagePicker().getImage(source: imageSource);
    if (pickedFileModelo != null) {
      selectImagePathModelo.value = pickedFileModelo.path;
    } else {
      print('No selecciono ninguna imagen');
    }
    Get.back();
    update();
  }

  // Elegir entre camara o foto
  void showAlertDialogModelo(context) {
    Widget galleryButton = TextButton(
      onPressed: () {
        pickImagenModelo(ImageSource.gallery);
      },
      child: Text('GALERIA'),
    );
    Widget cameraButton = TextButton(
      onPressed: () {
        pickImagenModelo(ImageSource.camera);
      },
      child: Text('CAMARA'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(
        'Selecciona tu imagen',
        style: Theme.of(context).textTheme.headline5,
      ),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
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
