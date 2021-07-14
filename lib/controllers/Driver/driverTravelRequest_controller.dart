import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Providers/geoFlutter_controller.dart';
import 'package:speed/controllers/Providers/travelInfo_provider.dart';
import 'package:speed/screen/Driver/driverTravelMap_screen.dart';
import 'package:speed/screen/Driver/homeDriver_screen.dart';

class DriverTravelRequestController extends GetxController {
  String from;
  String to;
  String idClient;

  final appData = GetStorage();
  // bool get isDark2 => appData.read('darkmode');
  //variables para guardar posicion
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Client client;
  // variables de contador
  Timer _timer;
  int seconds = 35;

  @override
  void onReady() {
    super.onReady();
    appData.write('isNotification', 'false');
    Map<String, dynamic> argumentos = Get.arguments;
    from = argumentos['origen'];
    to = argumentos['destino'];
    idClient = argumentos['idClient'];
    print('argumentoooooos $from');
    getClientInfo();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void getClientInfo() async {
    client = await ClientController().getById(idClient);
    update();
  }

  User getUser() {
    return _auth.currentUser;
  }

  // Seccion de aceptado el viaje
  void acceptDriver() {
    Map<String, dynamic> data = {
      'idDriver': getUser().uid,
      'status': 'accepted',
    };
    _timer?.cancel();
    // actualizamos los datos
    // cuando aceptemos le pasamos el idcliente para recuperar la info del viaje
    TravelInfoProvider().actualizar(data, idClient);
    Geoflutter().delete(getUser().uid);
    Get.offAll(
      () => DriverTravelMap(),
      transition: Transition.rightToLeft,
      arguments: idClient,
    );
    /* Get.off(
      () => DriverTravelMap(),
      transition: Transition.rightToLeft,
      arguments: idClient,
    ); */
  }

  // rechazar viaje
  void cancelTravel() {
    Map<String, dynamic> data = {
      'status': 'no_accepted',
    };
    _timer.cancel();
    // actualizamos los datos
    TravelInfoProvider().actualizar(data, idClient);
    Get.offAll(
      () => HomeDriver(),
      transition: Transition.rightToLeft,
    );
  }

  // Contador de respuesta
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = seconds - 1;
      update();
      if (seconds == 0) {
        cancelTravel();
      }
    });
  }
}
