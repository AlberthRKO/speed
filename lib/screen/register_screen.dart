import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/inputForm.dart';
import 'package:speed/components/shakeTransition.dart';
import 'package:speed/screen/login_screen.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      taman: size.width > 450 ? 800 : 650,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              children: [
                ReturnBack(),
                ShakeTransition(
                  axis: Axis.vertical,
                  duration: Duration(milliseconds: 2500),
                  child: SvgPicture.asset(
                    'assets/images/register.svg',
                    height: size.height > 450 ? size.height * 0.3 : 200,
                  ),
                ),
                BoxForm2(
                  child: Column(
                    children: [
                      ShakeTransition(
                        child: Column(
                          children: [
                            Text(
                              'Registrarse',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              width: 230,
                              child: Text(
                                'Create una cuenta para poder acceder a los servicios',
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: ShakeTransition(
                          axis: Axis.vertical,
                          duration: Duration(milliseconds: 2000),
                          child: Column(
                            children: [
                              InputControl(
                                hint: 'Nombre',
                                icon: FontAwesomeIcons.solidUser,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InputControl(
                                hint: 'Email',
                                icon: FontAwesomeIcons.solidUser,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InputControl2(hint: 'Contraseña'),
                              SizedBox(
                                height: 10,
                              ),
                              InputControl2(hint: 'Confirmar Contraseña'),
                            ],
                          ),
                        ),
                      ),
                      ShakeTransition2(
                        child: Button(
                          texto: 'Registrar',
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
          child: child,
        ),
      ),
    );
  }
}
