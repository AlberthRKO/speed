import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/components/sidebar.dart';
import 'package:speed/controllers/Driver/driverMap_controller.dart';
import 'package:speed/controllers/sidebar_controller.dart';
import 'package:speed/theme/themeChange.dart';

class HomeDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<DriverMapController>(
      init: DriverMapController(),
      builder: (_) {
        _.setMapStyle();
        TemaProvider().barState();
        return Scaffold(
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
                        initialCameraPosition: _.initialPosition,
                        onMapCreated: _.onMapCreate,
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        // hacemos que pinte el marker , pero solo su valor
                        markers: Set<Marker>.of(_.markers.values),
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
                                  'Conductor',
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
                            Button(
                              texto:
                                  _.isConnect ? 'Desconectarse' : 'Conectarse',
                              color: _.isConnect
                                  ? Colors.grey[200]
                                  : Theme.of(context).primaryColor,
                              funcion: () {
                                _.connect(context);
                              },
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
      },
    );
  }
}
