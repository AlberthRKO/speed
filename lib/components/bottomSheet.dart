import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/boxForm.dart';
import 'package:speed/screen/viewImagen_screen.dart';

class BottomSheetClient extends StatelessWidget {
  final String url;
  final String driverModelo;
  final String driverPlaca;
  final String driverLicencia;
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
    this.url = 'assets/images/yo.png',
    this.driverModelo = '',
    this.driverLicencia = '',
    this.driverPlaca = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Boxform(
      tamanBox: 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: size.width > 450
            ? ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        'Tu conductor',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Avatar(
                        backgroundImage: url != null
                            ? NetworkImage(url)
                            : AssetImage('assets/images/yo.png'),
                        radio: 40,
                      ),
                    ],
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
                  ImagenDriver(
                    backgroundImage: driverModelo != ''
                        ? NetworkImage(driverModelo)
                        : AssetImage('assets/images/modelo.png'),
                  ),
                  infoTravel(
                    context,
                    'Placa',
                    placa ?? '',
                    FontAwesomeIcons.car,
                  ),
                  ImagenDriver(
                    backgroundImage: driverPlaca != ''
                        ? NetworkImage(driverPlaca)
                        : AssetImage('assets/images/placa.png'),
                  ),
                  infoTravel(
                    context,
                    'Licencia',
                    '',
                    FontAwesomeIcons.car,
                  ),
                  ImagenDriver(
                    backgroundImage: driverLicencia != ''
                        ? NetworkImage(driverLicencia)
                        : AssetImage('assets/images/licencia.png'),
                  ),
                ],
              )
            : ListView(
                children: [
                  Column(
                    children: [
                      Text(
                        'Tu conductor',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.to(
                            ViewImagen(
                              imagen: NetworkImage(url),
                            ),
                          );
                        },
                        child: Avatar(
                          backgroundImage: url != null
                              ? NetworkImage(url)
                              : AssetImage('assets/images/yo.png'),
                          radio: 40,
                        ),
                      ),
                    ],
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
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.to(
                        ViewImagen(
                          imagen: NetworkImage(driverModelo),
                        ),
                      );
                    },
                    child: ImagenDriver(
                      backgroundImage: driverModelo != ''
                          ? NetworkImage(driverModelo)
                          : AssetImage('assets/images/modelo.png'),
                    ),
                  ),
                  infoTravel(
                    context,
                    'Placa',
                    placa ?? '',
                    FontAwesomeIcons.car,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.to(
                        ViewImagen(
                          imagen: NetworkImage(driverPlaca),
                        ),
                      );
                    },
                    child: ImagenDriver(
                      backgroundImage: driverPlaca != ''
                          ? NetworkImage(driverPlaca)
                          : AssetImage('assets/images/placa.png'),
                    ),
                  ),
                  infoTravel(
                    context,
                    'Licencia',
                    '',
                    FontAwesomeIcons.car,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.to(
                        ViewImagen(
                          imagen: NetworkImage(driverLicencia),
                        ),
                      );
                    },
                    child: ImagenDriver(
                      backgroundImage: driverLicencia != ''
                          ? NetworkImage(driverLicencia)
                          : AssetImage('assets/images/licencia.png'),
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
