import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed/Models/driver.dart';

class DriverController extends GetxController {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Drivers');

  // ignore: missing_return
  Future<void> create(Driver driver) {
    String errorMsg;
    try {
      return _reference.doc(driver.id).set(driver.toJson());
    } catch (e) {
      print(e);
      errorMsg = e.code;
    }
    if (errorMsg != null) {
      Future.error(errorMsg);
    }
  }

  // leemos los datos en tiempo real
  Stream<DocumentSnapshot> getByIdstream(String id) {
    return _reference.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Driver> getById(String id) async {
    DocumentSnapshot documentSnapshot = await _reference.doc(id).get();

    if (documentSnapshot.exists) {
      Driver driver = Driver.fromJson(documentSnapshot.data());
      return driver;
    } else {
      return null;
    }
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) {
    return _reference.doc(id).update(data);
  }
}
