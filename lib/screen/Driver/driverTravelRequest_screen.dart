import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/button.dart';
import 'package:speed/controllers/Driver/driverTravelRequest_controller.dart';

class DriverTravelRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<DriverTravelRequestController>(
      init: DriverTravelRequestController(),
      builder: (_) => Background(
        taman: size.width > 450 ? 800 : 650,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          child: Column(
            children: [
              Column(
                children: [
                  size.width > 450
                      ? Container()
                      : Avatar(
                          backgroundImage: AssetImage(
                            'assets/images/yo.jpg',
                          ),
                          radio: 45,
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _.client?.username ?? '',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              Expanded(
                child: BoxForm2(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          size.width > 450
                              ? Container()
                              : Lottie.asset(
                                  'assets/map_styles/loadingDriver.json',
                                  width: 150,
                                ),
                          Text(
                            'Información del viaje',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          infoTravel(
                            context,
                            'Recoger en:',
                            _.from ?? '',
                            FontAwesomeIcons.mapMarkedAlt,
                            () {},
                          ),
                          infoTravel(
                            context,
                            'Llevar a:',
                            _.to ?? '',
                            FontAwesomeIcons.mapMarkedAlt,
                            () {},
                          ),
                          infoTravel(
                            context,
                            'Precio:',
                            '${_?.price ?? ''} Bs',
                            FontAwesomeIcons.dollarSign,
                            () {},
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _.seconds.toString(),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Button2(
                                texto: 'Cancelar',
                                color: Colors.red,
                                funcion: _.cancelTravel,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 2,
                              child: Button(
                                texto: 'Aceptar',
                                color: Theme.of(context).primaryColor,
                                funcion: _.acceptDriver,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTravel(
      context, String info, String text, IconData icon, Function funcion) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: size.width > 450 ? 200 : double.infinity,
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).hintColor,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: GestureDetector(
                onTap: funcion,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      text,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxForm2 extends StatelessWidget {
  const BoxForm2({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        alignment: Alignment.center,
        width: size.width > 450 ? 400 : double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(-4, 6),
              blurRadius: 4,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: child,
        ),
      ),
    );
  }
}
