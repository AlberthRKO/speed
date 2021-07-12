import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/controllers/Providers/pushNotification_provider.dart';
import 'package:speed/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:speed/theme/themeChange.dart';

// ponemos async para que cargue en toda la app y mantenga la autenticacion
void main() async {
  // inicializamos firebase
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  // await PushNotificationProvider.verToken();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PushNotificationProvider pushNotificationProvider =
        new PushNotificationProvider();
    pushNotificationProvider.initPushNotificaction();
  }

  @override
  Widget build(BuildContext context) {
    TemaProvider().barState();
    return GetBuilder<TemaProvider>(
      init: TemaProvider(),
      builder: (_) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Speed',
        theme: _.theme,
        home: SplashScreen(),
      ),
    );
  }
}
