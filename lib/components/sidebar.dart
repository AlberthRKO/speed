import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed/components/avatar.dart';
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
            bottom: 70,
          ),
          // creamos el column para separarlo verticalmente
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // limitamos el ancho del sidebar
                constraints: BoxConstraints(maxWidth: (size.width / 2 - 15)),
                width: size.width,
                // column en el container para empezar al inicio
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* ClipOval(
                    child: Image.asset('assets/images/yo.jpg'),
                  ), */
                    //opcion para imagenes SVG y jpg
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
