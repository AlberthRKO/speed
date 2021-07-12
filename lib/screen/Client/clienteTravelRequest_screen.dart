import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/button.dart';
import 'package:speed/controllers/Client/clientTravelRequest_controller.dart';

class ClientTravelRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ClientTravelRequestController>(
      init: ClientTravelRequestController(),
      builder: (_) => Background(
        taman: size.width > 450 ? 800 : 650,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Avatar(
                    imagen: Image.asset(
                      'assets/images/yo.jpg',
                    ),
                    radio: 45,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Tu conductor',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Column(
                children: [
                  size.width > 450
                      ? SpinKitDoubleBounce(
                          color: Theme.of(context).primaryColor,
                        )
                      : Lottie.asset('assets/map_styles/loading.json'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Buscando conductor ...',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '0',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
              Button2(
                  texto: 'Cancelar Viaje', color: Colors.red, funcion: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
