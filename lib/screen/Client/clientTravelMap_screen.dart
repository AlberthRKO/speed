import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/controllers/Client/clientTravelMap_controller.dart';
import 'package:speed/theme/themeChange.dart';

class ClientTravelMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientTravelMapController>(
      init: ClientTravelMapController(),
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
                        left: 12,
                        right: 12,
                        bottom: 25,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconCircle(
                                function: () {},
                                icono: FontAwesomeIcons.solidUser,
                              ),
                              _infoTravel(
                                context,
                                'Estado del viaje',
                                _.curretStatus ?? '',
                                FontAwesomeIcons.info,
                              ),
                              IconCircle(
                                function: () {},
                                icono: FontAwesomeIcons.searchLocation,
                              ),
                            ],
                          ),
                        ],
                      ),
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
                size: 15,
                color: Theme.of(context).hintColor,
              ),
              SizedBox(
                width: 10,
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
