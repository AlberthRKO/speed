import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/button.dart';
import 'package:speed/controllers/Client/clientTravelCalification_controller.dart';

class ClientTravelCalification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ClientTravelCalificationController>(
      init: ClientTravelCalificationController(),
      builder: (_) => Background(
        taman: size.width > 450 ? 800 : 650,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              size.width > 450
                  ? Container()
                  : Column(
                      children: [
                        Lottie.asset(
                          'assets/map_styles/check.json',
                          width: 150,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'TU VIAJE HA FINALIZADO',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ],
                    ),
              BoxForm2(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      size.width > 450
                          ? 'Tu viaje ha finalizado'
                          : 'Informacion del viaje',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    infoTravel(
                      context,
                      'Desde',
                      'asdasdsad',
                      FontAwesomeIcons.mapMarkedAlt,
                    ),
                    infoTravel(
                      context,
                      'Hasta',
                      'asdasdsad asdsa',
                      FontAwesomeIcons.mapMarkedAlt,
                    ),
                    infoTravel(
                      context,
                      'Precio',
                      '15 Bs',
                      FontAwesomeIcons.dollarSign,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    size.width > 450
                        ? Container()
                        : Text(
                            'Calificar a tu conductor',
                            style: TextStyle(
                              color: Colors.cyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                    size.width > 450
                        ? Container()
                        : SizedBox(
                            height: 20,
                          ),
                    RatingBar.builder(
                      itemBuilder: (context, _) => Icon(
                        FontAwesomeIcons.solidStar,
                        color: Theme.of(context).primaryColor,
                      ),
                      unratedColor: Colors.grey,
                      itemCount: 5,
                      initialRating: 0,
                      allowHalfRating: true,
                      itemSize: 30,
                      itemPadding: EdgeInsets.symmetric(horizontal: 10),
                      direction: Axis.horizontal,
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
              ),
              Button(
                  texto: 'Calificar Viaje',
                  color: Theme.of(context).primaryColor,
                  funcion: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTravel(context, String info, String text, IconData icon) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: size.width > 450 ? 200 : double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                icon,
                size: 18,
                color: Theme.of(context).hintColor,
              ),
            ),
            Expanded(
              flex: 2,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: child,
        ),
      ),
    );
  }
}
