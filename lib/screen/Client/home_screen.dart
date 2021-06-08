import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/components/sidebar.dart';
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
            key: _.key,
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
              children: [
                Sidebar(),
                GetBuilder<SidebarController>(
                  init: SidebarController(),
                  builder: (_menu) => ContenedorAnimado(
                    isDrawerOpen: _menu.isDrawerOpen,
                    xOffset: _menu.xOffset,
                    yOffset: _menu.yOffset,
                    child: Stack(
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _.initialPosition,
                          onMapCreated: _.onMapCreate,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 8,
                            left: 8,
                            right: 8,
                            bottom: 25,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    style:
                                        Theme.of(context).textTheme.headline6,
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
                              Button(
                                texto: 'Solicitar Viaje',
                                color: Theme.of(context).primaryColor,
                                funcion: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
