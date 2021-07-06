import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';

class Geoflutter extends GetxController {
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Locations');
  Geoflutterfire _geo = Geoflutterfire();

  // funcion que almacenara la posicion en firestore
  Future<void> create(String id, double lat, double log) {
    GeoFirePoint myLocation = _geo.point(latitude: lat, longitude: log);
    return _reference
        .doc(id)
        .set({'status': 'drivers_available', 'position': myLocation.data});
  }

  // obtenemos los conductores en una consulta segun el status
  Stream<List<DocumentSnapshot>> getNearbyDriver(
      double lat, double log, double radius) {
    GeoFirePoint center = _geo.point(latitude: lat, longitude: log);
    return _geo
        .collection(
            collectionRef:
                _reference.where('status', isEqualTo: 'drivers_available'))
        .within(center: center, radius: radius, field: 'position');
  }

  // Para eliminar la posicion de firestore
  Future<void> delete(String id) {
    return _reference.doc(id).delete();
  }

  // Verfica en tiempo real el documento con el id enviado
  Stream<DocumentSnapshot> getLocationById(String id) {
    return _reference.doc(id).snapshots(includeMetadataChanges: true);
  }
}
