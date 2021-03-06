import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/shakeTransition.dart';
import 'package:speed/controllers/Client/clientHistoryDetail_controller.dart';
import 'package:speed/screen/viewImagen_screen.dart';

class ClientHistoryDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ClientHistoryDetailController>(
      init: ClientHistoryDetailController(),
      builder: (_) => Background(
        taman: size.width > 450 ? 800 : 650,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              width: double.infinity,
              // height: size.height * 0.96,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReturnBack(),
                  BoxForm2(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // titulo form
                        ShakeTransition(
                          duration: Duration(milliseconds: 3000),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Detalle del viaje',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: ShakeTransition(
                            axis: Axis.vertical,
                            duration: Duration(
                              milliseconds: 1500,
                            ),
                            typeAnimation: Curves.easeIn,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.to(
                                    ViewImagen(
                                      imagen: NetworkImage(_.driver?.image),
                                    ),
                                  ),
                                  child: Avatar(
                                    backgroundImage: _.driver?.image != null
                                        ? NetworkImage(_.driver?.image)
                                        : AssetImage('assets/images/yo.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Conductor',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _.driver?.username ?? '',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                infoTravel(
                                  context,
                                  'Origen',
                                  _.travelHistory?.from ?? '',
                                  FontAwesomeIcons.mapMarkedAlt,
                                ),
                                infoTravel(
                                  context,
                                  'Destino',
                                  _.travelHistory?.to ?? '',
                                  FontAwesomeIcons.mapMarkedAlt,
                                ),
                                infoTravel(
                                  context,
                                  'Mi calificaci??n',
                                  '${_.travelHistory?.calificationClient?.toString() ?? ''}',
                                  FontAwesomeIcons.solidStar,
                                ),
                                infoTravel(
                                  context,
                                  'Calificaci??n del conductor',
                                  '${_.travelHistory?.calificationDriver.toString() ?? ''}',
                                  FontAwesomeIcons.solidStar,
                                ),
                                infoTravel(
                                  context,
                                  'Precio del viaje',
                                  '${_.travelHistory?.price?.toString() ?? ''} Bs',
                                  FontAwesomeIcons.dollarSign,
                                ),
                                infoTravel(
                                  context,
                                  'Modelo',
                                  _.driver?.modelo ?? '',
                                  FontAwesomeIcons.carSide,
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(
                                    ViewImagen(
                                      imagen:
                                          NetworkImage(_.driver?.imageModelo),
                                    ),
                                  ),
                                  child: ImagenDriver(
                                    backgroundImage: _.driver?.imageModelo !=
                                            null
                                        ? NetworkImage(_.driver?.imageModelo)
                                        : AssetImage(
                                            'assets/images/modelo.png'),
                                  ),
                                ),
                                infoTravel(
                                  context,
                                  'Placa',
                                  _.driver?.placa ?? '',
                                  FontAwesomeIcons.carAlt,
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(
                                    ViewImagen(
                                      imagen:
                                          NetworkImage(_.driver?.imagePlaca),
                                    ),
                                  ),
                                  child: ImagenDriver(
                                    backgroundImage: _.driver?.imagePlaca !=
                                            null
                                        ? NetworkImage(_.driver?.imagePlaca)
                                        : AssetImage('assets/images/placa.png'),
                                  ),
                                ),
                                infoTravel(
                                  context,
                                  'Licencia',
                                  '',
                                  FontAwesomeIcons.carCrash,
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(
                                    ViewImagen(
                                      imagen:
                                          NetworkImage(_.driver?.imageLicencia),
                                    ),
                                  ),
                                  child: ImagenDriver(
                                    backgroundImage: _.driver?.imageLicencia !=
                                            null
                                        ? NetworkImage(_.driver?.imageLicencia)
                                        : AssetImage(
                                            'assets/images/licencia.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //tamanBox: 0.47,
                  ),
                ],
              ),
            ),
          ],
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

class ReturnBack extends StatelessWidget {
  ReturnBack({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 20,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'Atras',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
      ],
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
