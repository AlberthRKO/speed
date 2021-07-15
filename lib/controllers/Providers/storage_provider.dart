import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageProvider {
  Future<TaskSnapshot> uploadFile(PickedFile pickedFile) async {
    String name = UniqueKey().toString();

    // creamos la referencia inicando donde se guardara la imagen
    Reference reference =
        FirebaseStorage.instance.ref().child('images').child('/$name');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': pickedFile.path},
    );

    // crearemos el objeto q nos permitira guardar la imagen
    UploadTask uploadTask = reference.putFile(File(pickedFile.path), metadata);
    return uploadTask;
  }
}
