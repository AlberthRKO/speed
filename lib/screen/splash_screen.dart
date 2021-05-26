import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speed/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (_) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/splash.svg',
                width: 350,
              ),
              Column(
                children: [
                  Text(
                    'Speed',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
