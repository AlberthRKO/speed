import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:speed/Models/client.dart';

class ClientController extends GetxController {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Clients');

  Future<void> create(Client client) {
    try {
      _reference.doc(client.id).set(client.toJson());
    } catch (e) {
      print(e);
    }
  }
}
