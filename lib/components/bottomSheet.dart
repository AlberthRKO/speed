import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/boxForm.dart';

class BottomSheetClient extends StatelessWidget {
  final String url;
  final String nombre;
  final String correo;
  final String modelo;
  final String placa;

  const BottomSheetClient({
    Key key,
    @required this.nombre,
    @required this.correo,
    @required this.modelo,
    @required this.placa,
    this.url = 'assets/images/yo.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Boxform(
      tamanBox: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: size.width > 450
            ? Column(
                children: [
                  Text(
                    'Tu conductor',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      infoTravel(
                        context,
                        'Nombre',
                        nombre ?? '',
                        FontAwesomeIcons.solidUser,
                      ),
                      infoTravel(
                        context,
                        'Correo',
                        correo ?? '',
                        FontAwesomeIcons.solidEnvelope,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      infoTravel(
                        context,
                        'Modelo',
                        modelo ?? '',
                        FontAwesomeIcons.carSide,
                      ),
                      infoTravel(
                        context,
                        'Placa',
                        placa ?? '',
                        FontAwesomeIcons.car,
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Text(
                    'Tu conductor',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  size.width > 450
                      ? Container()
                      : Avatar(
                          imagen: Image.asset(
                            url,
                          ),
                          radio: 40,
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  infoTravel(
                    context,
                    'Nombre',
                    nombre ?? '',
                    FontAwesomeIcons.solidUser,
                  ),
                  infoTravel(
                    context,
                    'Correo',
                    correo ?? '',
                    FontAwesomeIcons.solidEnvelope,
                  ),
                  infoTravel(
                    context,
                    'Modelo',
                    modelo ?? '',
                    FontAwesomeIcons.carSide,
                  ),
                  infoTravel(
                    context,
                    'Placa',
                    placa ?? '',
                    FontAwesomeIcons.car,
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
