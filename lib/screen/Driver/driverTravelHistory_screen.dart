import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/components/background.dart';
import 'package:speed/controllers/Driver/driverTravelHistory_controller.dart';
import 'package:speed/utils/relative_time_util.dart';

class DriverTravelHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<DriverTravelHistoryController>(
      init: DriverTravelHistoryController(),
      builder: (_con) => Background(
        taman: size.width > 450 ? 750 : 550,
        child: Column(
          children: [
            ReturnBack(),
            Container(
              width: double.infinity,
              height: size.height * 0.8,
              child: FutureBuilder(
                future: _con.getAll(),
                builder:
                    (context, AsyncSnapshot<List<TravelHistory>> snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      return cardInfo(
                        context,
                        snapshot.data[index].nameClient,
                        snapshot.data[index].from,
                        snapshot.data[index].to,
                        snapshot.data[index].price?.toString(),
                        snapshot.data[index].calificationClient?.toString(),
                        RelativeTimeUtil.getRelativeTime(
                            snapshot.data[index].timestamp ?? 0),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardInfo(
    context,
    String name,
    String from,
    String to,
    String price,
    String calication,
    String timestamp,
  ) {
    return BoxForm2(
      child: Column(
        children: [
          infoTravel(
            context,
            'Cliente',
            name ?? '',
            FontAwesomeIcons.solidUser,
          ),
          infoTravel(
            context,
            'Desde',
            from ?? '',
            FontAwesomeIcons.mapMarkedAlt,
          ),
          infoTravel(
            context,
            'Hasta',
            to ?? '',
            FontAwesomeIcons.mapMarkedAlt,
          ),
          infoTravel(
            context,
            'Precio',
            price ?? '0 Bs',
            FontAwesomeIcons.dollarSign,
          ),
          infoTravel(
            context,
            'Calificación',
            calication ?? '',
            FontAwesomeIcons.solidStar,
          ),
          infoTravel(
            context,
            'Hace',
            timestamp ?? '',
            FontAwesomeIcons.solidClock,
          ),
        ],
      ),
    );
  }

  Widget infoTravel(context, String info, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8),
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
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            'Historial de Viajes',
            style: Theme.of(context).textTheme.button,
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
      padding: size.width > 450
          ? const EdgeInsets.symmetric(horizontal: 80, vertical: 10)
          : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: child,
        ),
      ),
    );
  }
}
