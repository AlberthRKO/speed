import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed/Models/travelHistory.dart';

class TravelHistoryProvider extends GetxController {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('TravelHistory');

  // ignore: missing_return
  Future<String> create(TravelHistory travelHistory) async {
    String errorMsg;
    try {
      // creamos id aleatorio y lo guardamos en nuestro esting y se lo asignamos
      // al id de la colleccion
      String id = _reference.doc().id;
      travelHistory.id = id;
      await _reference.doc().set(travelHistory.toJson());
      return id;
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

  Future<TravelHistory> getById(String id) async {
    DocumentSnapshot documentSnapshot = await _reference.doc(id).get();

    if (documentSnapshot.exists) {
      TravelHistory travelHistory =
          TravelHistory.fromJson(documentSnapshot.data());
      return travelHistory;
    } else {
      return null;
    }
  }

  Future<void> actualizar(Map<String, dynamic> data, String id) {
    return _reference.doc(id).update(data);
  }

  Future<void> eliminar(String id) {
    return _reference.doc(id).delete();
  }
}
