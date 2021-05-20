import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaProvider extends GetxController {
  var isDark = false;
  // creamos una variable para guardar el modo de nuestro tema
  SharedPreferences preferences;
  // String prefkey = "isDarkModeKey";

  void temaLight() {
    Get.changeTheme(
      ThemeData(
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
            fontSize: 16,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 13,
            color: Color(0XFF3B4661),
          ),
          bodyText2: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 15,
            color: Color(0XFF3B4661),
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    // preferences.setBool(prefkey, true);
  }

  //Variables de entorno para el tema dark
  void temaDark() {
    Get.changeTheme(
      ThemeData(
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
            fontSize: 16,
            color: Color(0XFF3B4661),
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 13,
            color: Colors.white,
          ),
          bodyText2: TextStyle(
            fontFamily: 'RubikI',
            fontSize: 15,
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // recibimos el estado y preguntamos envase a lo que sea se ejecute el tema
  void cambiarTema(bool estado) {
    if (estado) {
      // si es true cambiamos el estado del value isdark a true..
      //porque arrancaba en false en el switch
      temaDark();
      isDark = true;
    } else {
      temaLight();
      isDark = false;
    }
    // hacemos un update en el getX para que lee los cambios
    update();
  }

  /* // Indicamos que el metodo oninit que es el que empieza
  //la app cargue la preferencia

  @override
  void onInit() {
    // 
    cargarPreferencias().then((value) => cargarTema());
    super.onInit();
  }

  void cargarTema() {
    String prefkey = "isDarkModeKey";
    bool isDarkMoode = preferences.getBool(prefkey);
    if (isDarkMoode == null) {
      preferences.setBool(prefkey, false);
      isDarkMoode = false;
    }

    isDarkMoode ? temaDark() : temaLight();
  }

  // Creamos el metodo con la variable future
  // indicamos que es un metodo asincrono asique lo que devuleve tambien debe serlo
  Future<void> cargarPreferencias() async {
    preferences = await Get.putAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance(),
    );
  }

  // esto inicializa nuestra instancia de preferencias */
}