import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/Models/travelInfo.dart';
import 'package:speed/controllers/Providers/geoFlutter_controller.dart';
import 'package:speed/controllers/Providers/travelInfo_provider.dart';

class ClientTravelRequestController extends GetxController {
  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // variables de conductores cercanos
  StreamSubscription<List<DocumentSnapshot>> _streamNerbyDrivers;
  List<String> nearbyDrivers = [];

  @override
  void dispose() {
    super.dispose();
    _streamNerbyDrivers?.cancel();
  }

  // String idisito;

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> argumentos = Get.arguments;
    from = argumentos['from'];
    to = argumentos['to'];
    fromLatLng = argumentos['fromLatLng'];
    toLatLng = argumentos['toLatLng'];
    createTravelInfo();
    getNearbyDrivers();
  }

  User getUser() {
    return _auth.currentUser;
  }

  Future<void> createTravelInfo() async {
    TravelInfo travelInfo = TravelInfo(
      id: getUser().uid,
      from: from,
      to: to,
      fromLat: fromLatLng.latitude,
      fromLng: fromLatLng.longitude,
      toLat: toLatLng.latitude,
      toLng: toLatLng.longitude,
      status: 'created',
    );

    await TravelInfoProvider().create(travelInfo);
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = Geoflutter()
        .getNearbyDriver(fromLatLng.latitude, fromLatLng.longitude, 3);
    _streamNerbyDrivers = stream.listen((List<DocumentSnapshot> documentList) {
      for (DocumentSnapshot d in documentList) {
        print('Conductores Encontrados: ${d.id}');
        nearbyDrivers.add(d.id);
      }
    });
  }
}
