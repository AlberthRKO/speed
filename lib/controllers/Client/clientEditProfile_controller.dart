import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Providers/storage_provider.dart';
import 'package:speed/screen/Client/home_screen.dart';
import 'package:speed/utils/progress.dart';

class ClientEditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  PickedFile pickedFile;
  File imageFile;

  Client client;

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User getUser() {
    return _auth.currentUser;
  }

  void actualizar(context) async {
    String username = usernameController.text;

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
        'image': client?.image ?? null,
        'username': username,
      };

      await ClientController().actualizar(data, getUser().uid);
    } else {
      TaskSnapshot snapshot = await StorageProvider().uploadFile(pickedFile);
      // capturamos la url de la imagen
      String imageUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> data = {
        'image': imageUrl,
        'username': username,
      };

      await ClientController().actualizar(data, getUser().uid);
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
        Get.off(
          () => Home(),
          transition: Transition.upToDown,
        );
      },
    );
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
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
        getImageFromGallery(ImageSource.gallery);
      },
      child: Text('GALERIA'),
    );
    Widget cameraButton = TextButton(
      onPressed: () {
        getImageFromGallery(ImageSource.camera);
      },
      child: Text('CAMARA'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
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
    client = await ClientController().getById(getUser().uid);
    usernameController.text = client.username;
    update();
  }
}
