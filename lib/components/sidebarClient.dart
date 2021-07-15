import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/menuOption.dart';
import 'package:speed/controllers/Client/clientMap_controller.dart';
import 'package:speed/controllers/sidebar_controller.dart';
import 'package:speed/theme/themeChange.dart';

class SidebarClient extends StatelessWidget {
  const SidebarClient({
    Key key,
    this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    TemaProvider().barState();
    Size size = MediaQuery.of(context).size;
    // construimos el builder para el dark o light
    return GetBuilder<TemaProvider>(
      init: TemaProvider(),
      builder: (_theme) => Container(
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
                GetBuilder<ClientMapController>(
                  init: ClientMapController(),
                  builder: (_info) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar(
                        backgroundImage: _info.client?.image != null
                            ? NetworkImage(_info.client?.image)
                            : AssetImage('assets/images/yo.jpg'),
                        radio: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _info.client?.username ?? 'Nombre de usuario',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        _info.client?.email ?? 'Correo electrónico',
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
                            'Modo ' + _theme.typeTheme(),
                          ),
                          Switch(
                            value: _theme.isDark,
                            onChanged: (estado) {
                              _theme.cambiarTema(estado);
                            },
                          ),
                        ],
                      ),
                      MenuOption(
                        icono: FontAwesomeIcons.user,
                        text: 'Perfil',
                        link: _info.goEditProfile,
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
                ),

                GetBuilder<SidebarController>(
                  init: SidebarController(),
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
