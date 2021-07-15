import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/components/background.dart';
import 'package:speed/controllers/Client/clientTravelHistory_controller.dart';

class ClientTravelHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ClientTravelHistoryController>(
      init: ClientTravelHistoryController(),
      builder: (_con) => Background(
        taman: size.width > 450 ? 750 : 550,
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
                  FutureBuilder(
                    builder:
                        (context, AsyncSnapshot<List<TravelHistory>> snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return BoxForm2(
                            child: Column(
                              children: [
                                infoTravel(
                                  context,
                                  'Desde',
                                  snapshot.data[index].from ?? '',
                                  FontAwesomeIcons.mapMarkedAlt,
                                ),
                                infoTravel(
                                  context,
                                  'Hasta',
                                  snapshot.data[index].to ?? '',
                                  FontAwesomeIcons.mapMarkedAlt,
                                ),
                                infoTravel(
                                  context,
                                  'Precio',
                                  '${snapshot.data[index].price?.toString() ?? ''} Bs',
                                  FontAwesomeIcons.dollarSign,
                                ),
                                infoTravel(
                                  context,
                                  'Calificación',
                                  '${snapshot.data[index].calificationDriver?.toString() ?? ''}',
                                  FontAwesomeIcons.solidStar,
                                ),
                                infoTravel(
                                  context,
                                  'Hace',
                                  '${snapshot.data[index].timestamp?.toString() ?? ''}',
                                  FontAwesomeIcons.solidClock,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // widget creado para animacion
                  BoxForm2(
                    child: Column(
                      children: [
                        infoTravel(
                          context,
                          'Desde',
                          'asdsaas sa',
                          FontAwesomeIcons.mapMarkedAlt,
                        ),
                        infoTravel(
                          context,
                          'Hasta',
                          'asdsaas sa',
                          FontAwesomeIcons.mapMarkedAlt,
                        ),
                        infoTravel(
                          context,
                          'Precio',
                          'asdsaas sa',
                          FontAwesomeIcons.dollarSign,
                        ),
                        infoTravel(
                          context,
                          'Desde',
                          'asdsaas sa',
                          FontAwesomeIcons.accusoft,
                        ),
                        infoTravel(
                          context,
                          'Calificación',
                          'asdsaas sa',
                          FontAwesomeIcons.solidStar,
                        ),
                        infoTravel(
                          context,
                          'Hace',
                          'asdsaas sa',
                          FontAwesomeIcons.solidClock,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
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
              size: 15,
              color: Theme.of(context).hintColor,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '$info: ',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Expanded(
                    child: Text(
                      text,
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: child,
        ),
      ),
    );
  }
}
