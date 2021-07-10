import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/components/sidebarClient.dart';
import 'package:speed/controllers/Client/clientMap_controller.dart';
import 'package:speed/controllers/sidebar_controller.dart';
import 'package:speed/theme/themeChange.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TemaProvider().barState();
    return GetBuilder<ClientMapController>(
      init: ClientMapController(),
      builder: (_) {
        _.setMapStyle();
        TemaProvider().barState();
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: [
              SidebarClient(),
              GetBuilder<SidebarController>(
                init: SidebarController(),
                builder: (_menu) => ContenedorAnimado(
                  isDrawerOpen: _menu.isDrawerOpen,
                  xOffset: _menu.xOffset,
                  yOffset: _menu.yOffset,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: _.initialPosition,
                        onMapCreated: _.onMapCreate,
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        // hacemos que pinte el marker , pero solo su valor
                        markers: Set<Marker>.of(_.markers.values),
                        onCameraMove: (position) {
                          _.initialPosition = position;
                          print('On Camera Move: $position');
                        },
                        onCameraIdle: () async {
                          await _.setLocationScrollInfo();
                        },
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => _menu.abrirSidebar(size),
                                  icon: Icon(
                                    FontAwesomeIcons.bars,
                                    size: 20,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                Text(
                                  'Pasajero',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                IconButton(
                                  onPressed: () => _.volver(),
                                  icon: Icon(
                                    FontAwesomeIcons.searchLocation,
                                    size: 20,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                            cardPlaces(
                                context,
                                _.from,
                                _.to,
                                _.isFromSelect,
                                _.isToSelect,
                                _.changeFromTo,
                                _.changeFromSoli,
                                _),
                            Expanded(child: Container()),
                            Button(
                              texto: 'Solicitar',
                              color: Theme.of(context).primaryColor,
                              funcion: () {
                                _.goInfotravel(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/pinUsuario.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          // cardPlaces(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget cardPlaces(
      context,
      String from,
      String to,
      bool isChange,
      bool toChange,
      Function cambio,
      Function confirm,
      ClientMapController client) {
    return BoxForm2(
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.mapPin,
                size: 18,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await client.showGoogleAutocomplete(true, context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desde',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                      Text(
                        from ?? 'Origen',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: cambio,
                child: Icon(
                  isChange
                      ? FontAwesomeIcons.checkCircle
                      : FontAwesomeIcons.solidCheckCircle,
                  size: 18,
                  color: isChange ? Theme.of(context).hintColor : Colors.green,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[600],
          ),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.mapPin,
                size: 18,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await client.showGoogleAutocomplete(false, context);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasta',
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                      Text(
                        to ?? 'Destino',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: confirm,
                child: Icon(
                  toChange
                      ? FontAwesomeIcons.checkCircle
                      : FontAwesomeIcons.solidCheckCircle,
                  size: 18,
                  color: toChange ? Theme.of(context).hintColor : Colors.green,
                ),
              ),
            ],
          )
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
