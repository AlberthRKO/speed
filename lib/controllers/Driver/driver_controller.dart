import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed/Models/driver.dart';

class DriverController extends GetxController {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Drivers');

  Future<void> create(Driver driver) {
    try {
      _reference.doc(driver.id).set(driver.toJson());
    } catch (e) {
      print(e);
    }
  }
}
