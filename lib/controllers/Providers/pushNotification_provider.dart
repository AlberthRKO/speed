import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // informacion que nos mandara cada vez que reciba una notificacion
  // ignore: close_sinks
  StreamController _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  static String token;

  Stream<Map<String, dynamic>> get message => _streamController.stream;

  void initPushNotificaction() {
    /* _firebaseMessaging.configure(
      // informacion que sera enviada por la notificacion
      onMessage: (Map<String, dynamic> message) {
        print('OnMessage: $message');
        _streamController.sink.add(message);
      },
      // esto recibira los valores que nos llegan atraves de la notificacion
      onLaunch: (Map<String, dynamic> message) {
        print('OnLauch: $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('OnResume: $message');
        _streamController.sink.add(message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
        provisional: true,
      ),
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Las configuraciones para ios fueron registradas $settings');
    }); */

    // ONMESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      Map<String, dynamic> data = message.data;
      print('OnMessage: $data');
      _streamController.sink.add(data);
    });

    // ONRESUME
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Map<String, dynamic> data = message.data;
      print('OnResume: $data');
      _streamController.sink.add(data);
    });
  }

  // creamos un token en el cliente o conductor
  void saveToken(String idUser, String typeUser) async {
    // generar token para q la notificacion sea a una persona
    String token = await _firebaseMessaging.getToken();

    Map<String, dynamic> data = {
      'token': token,
    };

    // print('TOKENNNNNNNNNNNNNNNNNNNNN: $token');
    if (typeUser == 'Client') {
      ClientController().actualizar(data, idUser);
    } else {
      DriverController().actualizar(data, idUser);
    }
  }

  /* static Future verToken() async {
    token = await FirebaseMessaging.instance.getToken();
    print('TOKENNNNNNNNNNNNNNNNNNNNN: $token');
  } */

}
