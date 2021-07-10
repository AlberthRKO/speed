import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/components/boxForm.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/controllers/Client/clientTravelInfoController.dart';
import 'package:speed/theme/themeChange.dart';

class ClienteTravelInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientTravelInfoController>(
      init: ClientTravelInfoController(),
      builder: (_) {
        _.setMapStyle();
        TemaProvider().barState();
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: [
              ContenedorAnimado(
                xOffset: 0,
                yOffset: 0,
                isDrawerOpen: false,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: GoogleMap(
                        initialCameraPosition: _.initialPosition,
                        onMapCreated: _.onMapCreate,
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        // hacemos que pinte el marker , pero solo su valor
                        markers: Set<Marker>.of(_.markers.values),
                        polylines: _.polylines,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 8,
                        right: 8,
                        bottom: 25,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _.animatePosition2,
                                child: _infoTravel(
                                    context,
                                    'Distancia',
                                    _.distancia ?? 'Distancia',
                                    FontAwesomeIcons.carSide),
                              ),
                              _infoTravel(
                                  context,
                                  'Tiempo',
                                  _.tiempo ?? 'Tiempo',
                                  FontAwesomeIcons.solidClock),
                            ],
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: cardInfo(context, _),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _infoTravel(context, String info, String text, IconData icon) {
    return BoxFormInfo(
      child: Column(
        children: [
          Row(
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
                      style: TextStyle(fontSize: 8, color: Colors.grey),
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
        ],
      ),
    );
  }

  Widget cardInfo(context, ClientTravelInfoController _) {
    Size size = MediaQuery.of(context).size;
    return Boxform(
      tamanBox: 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          size.width > 450
              ? Row(
                  children: [
                    infoTravel(
                      context,
                      'Desde',
                      _.from,
                      FontAwesomeIcons.mapMarkedAlt,
                      _.origenPos,
                    ),
                    infoTravel(
                      context,
                      'Hasta',
                      _.to,
                      FontAwesomeIcons.mapMarkedAlt,
                      _.destinoPos,
                    ),
                    infoTravel(
                      context,
                      'Precio Aproximado',
                      '${_.minTotal ?? '0.0'}\Bs - ${_.maxTotal ?? '0.0'}\Bs',
                      FontAwesomeIcons.dollarSign,
                      () {},
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    infoTravel(
                      context,
                      'Desde',
                      _.from,
                      FontAwesomeIcons.mapMarkedAlt,
                      _.origenPos,
                    ),
                    infoTravel(
                      context,
                      'Hasta',
                      _.to,
                      FontAwesomeIcons.mapMarkedAlt,
                      _.destinoPos,
                    ),
                    infoTravel(
                      context,
                      'Precio Aproximado',
                      '${_.minTotal ?? '0.0'}\Bs - ${_.maxTotal ?? '0.0'}\Bs',
                      FontAwesomeIcons.dollarSign,
                      () {},
                    ),
                  ],
                ),
          Flexible(
            child: Button(
              texto: 'Confirmar',
              color: Theme.of(context).primaryColor,
              funcion: _.goRequestSoli,
            ),
          ),
        ],
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

class BoxFormInfo extends StatelessWidget {
  const BoxFormInfo({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        alignment: Alignment.center,
        width: size.width / 2 > 225 ? 200 : 150,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: child,
        ),
      ),
    );
  }
}
