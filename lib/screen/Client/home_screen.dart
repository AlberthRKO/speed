import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              child: mapaUser(size, _menu, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget mapaUser(Size size, SidebarController _menu, BuildContext context) {
    return GetBuilder<ClientMapController>(
      init: ClientMapController(),
      builder: (_) {
        _.setMapStyle();
        TemaProvider().barState();
        return Stack(
          children: [
            Container(
              width: size.width * 1,
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: _.initialPosition,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: _.onMapCreate,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
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
                        'Speed',
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
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
