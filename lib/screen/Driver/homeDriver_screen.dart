import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/components/sidebar.dart';
import 'package:speed/controllers/Driver/driverMap_controller.dart';
import 'package:speed/controllers/sidebar_controller.dart';

class HomeDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<SidebarController>(
      init: SidebarController(),
      builder: (_menu) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            Sidebar(),
            ContenedorAnimado(
              isDrawerOpen: _menu.isDrawerOpen,
              xOffset: _menu.xOffset,
              yOffset: _menu.yOffset,
              child: GetBuilder<DriverMapController>(
                init: DriverMapController(),
                builder: (_) {
                  _.setMapStyle();
                  return Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: _.initialPosition,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: _.onMapCreate,
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
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
