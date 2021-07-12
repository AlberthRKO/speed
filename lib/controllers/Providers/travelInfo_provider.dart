import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speed/Models/travelInfo.dart';

class TravelInfoProvider {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('TravelInfo');

  // Funcion para crear informacion
  // ignore: missing_return
  Future<void> create(TravelInfo travelInfo) {
    String errorMsg;
    try {
      return _reference.doc(travelInfo.id).set(travelInfo.toJson());
    } catch (e) {
      print(e);
      errorMsg = e.code;
    }
    if (errorMsg != null) {
      Future.error(errorMsg);
    }
  }
}
