import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// ponemos async para que cargue en toda la app y mantenga la autenticacion
void main() async {
  // inicializamos firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speed',
      theme: ThemeData(
        primaryColor: Color(0XFFE7D42F),
        accentColor: Color(0XFF3B4661),
        backgroundColor: Color(0xFFF8F7FC),
        hintColor: Color(0XFF3B4661),
        cardColor: Colors.white,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 40,
            color: Color(0XFF3B4661),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 30,
            color: Color(0XFF3B4661),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          // para titulo de los accesos
          headline4: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 27,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
          // Para los Selectores de usuario
          headline3: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 20,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
          // Para los titulos de nombre
          headline5: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 18,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
          // cabecera de speed
          headline6: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 25,
            color: Color(0XFF3B4661),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 16,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 13,
            color: Color(0XFF3B4661),
          ),
          bodyText1: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 15,
            color: Color(0XFF3B4661),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
          subtitle2: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 13,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
