import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/controllers/Providers/pushNotification_provider.dart';
import 'package:speed/screen/Client/clientHistoryDetail_screen.dart';
import 'package:speed/screen/Driver/driverTravelRequest_screen.dart';
import 'package:speed/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:speed/theme/themeChange.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// ponemos async para que cargue en toda la app y mantenga la autenticacion
void main() async {
  // inicializamos firebase
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await PushNotificationProvider.verToken();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    PushNotificationProvider pushNotificationProvider =
        new PushNotificationProvider();
    pushNotificationProvider.initPushNotificaction();
    pushNotificationProvider.message.listen((data) {
      print('-------------Notificacion-------------');
      print(data);

      // navigatorKey.currentState
      //     .popAndPushNamed('driver/travel/request', arguments: data);
      Get.to(
        () => DriverTravelRequest(),
        transition: Transition.leftToRight,
        arguments: data,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TemaProvider().barState();
    return GetBuilder<TemaProvider>(
      init: TemaProvider(),
      builder: (_) => GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Speed',
        theme: _.theme,
        home: SplashScreen(),
        routes: {
          'driver/travel/request': (BuildContext context) =>
              DriverTravelRequest(),
        },
      ),
    );
  }
}
