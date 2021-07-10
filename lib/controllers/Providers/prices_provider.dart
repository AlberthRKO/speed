import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speed/Models/prices.dart';

class PricesProvider {
  CollectionReference _ref = FirebaseFirestore.instance.collection('Prices');

  Future<Prices> getAll() async {
    DocumentSnapshot document = await _ref.doc('info').get();
    if (document.exists) {
      Prices prices = Prices.fromJson(document.data());
      return prices;
    } else {
      print('No hay precios');
      return null;
    }
  }
}
