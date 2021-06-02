import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed/Models/client.dart';

class ClientController extends GetxController {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Clients');

  // Esto crea una coleccion en la DB recibiendo
  //como dato el Client model que luego lo pasamos a Json
  Future<void> create(Client client) {
    String errorMsg;
    try {
      return _reference.doc(client.id).set(client.toJson());
    } catch (e) {
      print(e);
      errorMsg = e.code;
    }
    if (errorMsg != null) {
      return Future.error(errorMsg);
    }
  }

  // esta funcion nos devolvera el modelo client cuando le pasemos su id
  Future<Client> getById(String id) async {
    // esto hace una consulta a la DB que nos trae el client
    // la funcion devuelve un archivo de tipo documentSnapchot asi que lo pasamos
    DocumentSnapshot documentSnapshot = await _reference.doc(id).get();

    if (documentSnapshot.exists) {
      // ahora convertimos el document que es un objeto a tipo client
      Client client = Client.fromJson(documentSnapshot.data());
      print('existeeeee');
      return client;
    } else {
      print('no hay nadaaaa');
      return null;
    }
  }
}
