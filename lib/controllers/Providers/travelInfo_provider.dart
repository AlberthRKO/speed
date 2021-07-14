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

  Future<TravelInfo> getById(String id) async {
    // esto hace una consulta a la DB que nos trae el client
    // la funcion devuelve un archivo de tipo documentSnapchot asi que lo pasamos
    DocumentSnapshot documentSnapshot = await _reference.doc(id).get();

    if (documentSnapshot.exists) {
      // ahora convertimos el document que es un objeto a tipo client
      TravelInfo travelInfo = TravelInfo.fromJson(documentSnapshot.data());
      print('existeeeee');
      return travelInfo;
    } else {
      print('no hay nadaaaa');
      return null;
    }
  }

  // Metodo que nos permitira actualizar informacion en firebase
  Future<void> actualizar(Map<String, dynamic> data, String id) {
    return _reference.doc(id).update(data);
  }

  // Escuchar en tiempo real si el conductor acepto el viaje
  Stream<DocumentSnapshot> getByIdStrem(String id) {
    return _reference.doc(id).snapshots(includeMetadataChanges: true);
  }
}
