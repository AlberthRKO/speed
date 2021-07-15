import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';

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
      await _reference.doc(travelHistory.id).set(travelHistory.toJson());
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

  // Funcion para tener todas las respuestas en las que haya un id client
  // tenddremos una lista de modelos de travelHistory
  Future<List<TravelHistory>> getByIdClient(String idClient) async {
    QuerySnapshot querySnapshot = await _reference
        .where('idClient', isEqualTo: idClient)
        .orderBy('timestamp', descending: true)
        .get();
    // Pasamos la respuesta del query en una lista
    List allData = [];
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Convertimos el mapa a una lista de tipo travelHistory
    List<TravelHistory> travelHistoryList = [];

    for (Map<String, dynamic> data in allData) {
      // y asi llenamos puros objetos de tipo travelHistory
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    // hacemos un recorrido por la lista para agregar el username del driver
    for (TravelHistory travelHistory in travelHistoryList) {
      Driver driver = await DriverController().getById(travelHistory.idDriver);
      travelHistory.nameDriver = driver.username;
    }

    return travelHistoryList;
  }

  Future<List<TravelHistory>> getByIdDriver(String idDriver) async {
    QuerySnapshot querySnapshot = await _reference
        .where('idDriver', isEqualTo: idDriver)
        .orderBy('timestamp', descending: true)
        .get();
    // Pasamos la respuesta del query en una lista
    List allData = [];
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Convertimos el mapa a una lista de tipo travelHistory
    List<TravelHistory> travelHistoryList = [];

    for (Map<String, dynamic> data in allData) {
      // y asi llenamos puros objetos de tipo travelHistory
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    // hacemos un recorrido por la lista para agregar el username del driver
    for (TravelHistory travelHistory in travelHistoryList) {
      Client client = await ClientController().getById(travelHistory.idClient);
      travelHistory.nameClient = client.username;
    }

    return travelHistoryList;
  }
}
