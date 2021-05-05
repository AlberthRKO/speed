import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed/screen/splash_screen.dart';

void main() {
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
      home: Splash_screen(),
    );
  }
}
