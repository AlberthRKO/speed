import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/controllers/Client/clientMap_controller.dart';

class TemaProvider extends GetxController {
  final appData = GetStorage();
  bool get isDark => appData.read('darkmode') ?? false;
  ThemeData get theme => isDark ? temaDark() : temaLight();

  String typeTheme() => isDark ? 'Oscuro' : 'Claro';

  @override
  void onReady() {
    super.onReady();
    barState();
  }

  Future<void> barState() {
    if (isDark)
      return FlutterStatusbarManager.setStyle(StatusBarStyle.LIGHT_CONTENT);
    else
      return FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
  }

  // String prefkey = "isDarkModeKey";

  ThemeData temaLight() {
    return ThemeData(
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
        headline4: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 27,
          color: Color(0XFF3B4661),
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 20,
          color: Color(0XFF3B4661),
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 18,
          color: Color(0XFF3B4661),
          fontWeight: FontWeight.bold,
        ),
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
    );

    // preferences.setBool(prefkey, true);
  }

  //Variables de entorno para el tema dark
  ThemeData temaDark() {
    return ThemeData(
      primaryColor: Color(0XFFE7D42F),
      accentColor: Color(0XFF3B4661),
      backgroundColor: Color(0xFF252737),
      hintColor: Colors.white,
      cardColor: Color(0XFF2D2F3F),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 40,
          color: Colors.white,
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
        headline4: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 27,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 25,
          color: Colors.white,
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
          color: Colors.white,
        ),
        bodyText1: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 15,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        ),
        subtitle2: TextStyle(
          fontFamily: 'RubikI',
          fontSize: 13,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // recibimos el estado y preguntamos envase a lo que sea se ejecute el tema
  void cambiarTema(bool estado) {
    appData.write('darkmode', estado);
    /* if (isDark)
      FlutterStatusbarManager.setStyle(StatusBarStyle.LIGHT_CONTENT);
    else
      FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT); */

    /* print(isDarkk);
    print(modo); */
    // hacemos un update en el getX para que lee los cambios
    update();
  }
}
