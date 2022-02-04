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

class DriverEditProfileController extends GetxController {
  // instanciamos auth de firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final modeloController = TextEditingController();
  final placaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  bool success;
  String userEmail;

  PickedFile pickedFile;
  File imageFile;
  File imagenDriver;
  var selectImagePath = ''.obs;
  var selectImageSize = ''.obs;

  Driver driver;

  User getUser() {
    return _auth.currentUser;
  }

  Future<void> actualizar(context) async {
    String nombre = nameController.text;
    String model = modeloController.text;
    String placa = placaController.text;
    ProgressDialog pr = Progresso.crearProgress(context, 'Actualizando...');

    if (formKey.currentState.validate()) {
      print('Formulario valido');
    } else {
      print('Formulario invalido');
      return;
    }
    pr.show();

    // validamos
    if (pickedFile == null) {
      Map<String, dynamic> data = {
        'image': driver?.image ?? null,
        'username': nombre,
        'modelo': model,
        'placa': placa,
      };

      await DriverController().actualizar(data, getUser().uid);
    } else {
      TaskSnapshot snapshot = await StorageProvider().uploadFile(pickedFile);
      // capturamos la url de la imagen
      String imageUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> data = {
        'image': imageUrl,
        'username': nombre,
        'modelo': model,
        'placa': placa,
      };

      await DriverController().actualizar(data, getUser().uid);
    }
    pr.hide();

    Get.snackbar(
      'Actualización exitosa', //titulo
      'La informacion se actualizo con éxito',
      backgroundColor: Theme.of(context).cardColor,
      // icon: Icon(FontAwesomeIcons.solidLaughWink),
      colorText: Theme.of(context).hintColor,
    );
    Future.delayed(
      Duration(seconds: 2),
      () {
        Get.back();
        Get.back();
      },
    );
  }

  /* Future getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      print('kheeeeee $imageFile');
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

  void getUserInfo() async {
    driver = await DriverController().getById(getUser().uid);
    nameController.text = driver.username;
    modeloController.text = driver.modelo;
    placaController.text = driver.placa;
    update();
  }
}
