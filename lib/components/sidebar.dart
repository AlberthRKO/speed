import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/menuOption.dart';
import 'package:speed/controllers/login_controller.dart';
import 'package:speed/theme/themeChange.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // construimos el builder para el dark o light
    return GetBuilder<TemaProvider>(
      init: TemaProvider(),
      builder: (_) => Container(
        // damos tamaño al container y que arranque del inicio
        // ya que el sgte container tiene un maxwidth
        width: size.width,
        alignment: Alignment.centerLeft,
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            left: 20,
            bottom: 50,
          ),
          // creamos el column para separarlo verticalmente
          child: Container(
            // limitamos el ancho del sidebar
            constraints: BoxConstraints(maxWidth: (size.width / 2 - 15)),
            width: size.width,
            // column en el container para empezar al inicio
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* ClipOval(
                child: Image.asset('assets/images/yo.jpg'),
              ), */
                //opcion para imagenes SVG y jpg
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Avatar(
                      imagen: Image.asset(
                        'assets/images/yo.jpg',
                      ),
                      radio: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Alberth Paredes',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'alberth@alberth.com',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Modo ' + _.modo,
                        ),
                        Switch(
                          value: _.isDark,
                          onChanged: (estado) {
                            _.cambiarTema(estado);
                          },
                        ),
                      ],
                    ),
                    MenuOption(
                      icono: FontAwesomeIcons.user,
                      text: 'Perfil',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MenuOption(
                      icono: FontAwesomeIcons.history,
                      text: 'Historial de Viajes',
                    ),
                  ],
                ),
                GetBuilder<LoginController>(
                  init: LoginController(),
                  builder: (_) => MenuOption(
                    link: () => _.cerrarSesion(context),
                    icono: FontAwesomeIcons.signOutAlt,
                    text: 'Salir',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
