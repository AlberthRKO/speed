import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/Models/travelInfo.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:speed/controllers/Providers/geoFlutter_controller.dart';
import 'package:speed/controllers/Providers/pushNotification_provider.dart';
import 'package:speed/controllers/Providers/travelInfo_provider.dart';
import 'package:speed/screen/Client/clientTravelMap_screen.dart';
import 'package:speed/screen/Client/home_screen.dart';
import 'package:speed/utils/snackBar.dart';

class ClientTravelRequestController extends GetxController {
  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // variables de conductores cercanos
  StreamSubscription<List<DocumentSnapshot>> _streamNerbyDrivers;
  List<String> nearbyDrivers = [];

  StreamSubscription<DocumentSnapshot<Object>> _streamAccept;

  @override
  void dispose() {
    super.dispose();
    _streamNerbyDrivers?.cancel();
    _streamAccept?.cancel();
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
    // lo ponemos despues de crear la informacion
    _checkAccepted();
  }

  void getNearbyDrivers() {
    Stream<List<DocumentSnapshot>> stream = Geoflutter()
        .getNearbyDriver(fromLatLng.latitude, fromLatLng.longitude, 3);
    _streamNerbyDrivers = stream.listen((List<DocumentSnapshot> documentList) {
      for (DocumentSnapshot d in documentList) {
        print('Conductores Encontrados: ${d.id}');
        nearbyDrivers.add(d.id);
      }
      getDriverInfo(nearbyDrivers[0]);
      // eliminamos el stream..porque solo necesitamos una vez
      _streamNerbyDrivers?.cancel();
    });
  }

  // metodo para obtener el token del usuario mediante el id
  Future<void> getDriverInfo(String id) async {
    Driver driver = await DriverController().getById(id);
    print('TOKENNNNNNNNNNNNNNNNN ${driver.token}');
    sendNotification(driver.token);
  }

  // Funcion para enviar notificacion
  void sendNotification(String token) {
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'idClient': getUser().uid,
      'origen': from,
      'destino': to,
    };
    print('DATOSSSSSSSS $data');
    PushNotificationProvider().sendMessage(
      token,
      data,
      'Solcitud de Viaje',
      'Un cliente esta solicitando un viaje',
    );
  }

  // Metodopara saber si acepto el viaje
  void _checkAccepted() {
    Stream<DocumentSnapshot> stream =
        TravelInfoProvider().getByIdStrem(getUser().uid);
    // escuhamos la respuesta
    _streamAccept = stream.listen((DocumentSnapshot document) {
      TravelInfo travelInfo = TravelInfo.fromJson(document.data());
      if (travelInfo.idDriver != null && travelInfo.status == 'accepted') {
        Get.offAll(
          () => ClientTravelMap(),
          transition: Transition.rightToLeft,
        );
        /* Get.off(
          () => ClientTravelMap(),
          transition: Transition.rightToLeft,
        ); */
      } else if (travelInfo.status == 'no_accepted') {
        snackError(
            title: 'Viaje Rechazado',
            msg: 'El conductor no acepto tu solicitud');
        Future.delayed(
          Duration(milliseconds: 2000),
          () => Get.offAll(
            () => Home(),
            transition: Transition.rightToLeft,
          ),
        );
      }
    });
  }
}
