import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:http/http.dart' as http;

class PushNotificationProvider extends GetxController {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // informacion que nos mandara cada vez que reciba una notificacion
  StreamController _streamController =
      StreamController<Map<String, dynamic>>.broadcast();

  static String token;

  // variables de dio
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  final appData = GetStorage();

  // PushNotificationProvider({Dio dio}) : _dio = dio ?? Dio();

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

    // ONLAUCH
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Map<String, dynamic> data = message.data;
        appData.write('isNotification', 'true');
        String notifi = appData.read('isNotification');
        print('segundaaaaaaaaa $notifi');
        _streamController.sink.add(data);
      }
    });

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

  // Metodo para enviar las notificaciones push
  Future<void> sendMessage(
      String to, Map<String, dynamic> data, String title, String body) async {
    await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAYMb7msI:APA91bHvKvgT89vCpoOHpb9rZEqGBHNu5DdVlHCMh9VyrVfw_zUWd_uAqUh8VSC-S-9JpqCLOLy611I3-bBgLcz3aKzgP5H5YZle5OxnRphep5v0x-tML57LkH_8bphd1pkwrgbhqD0-'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }));
  }

  void streamsApagar() {
    _streamController?.close();
  }
}
