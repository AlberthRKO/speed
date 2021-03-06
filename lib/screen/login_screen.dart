import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/actionAccess.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/inputForm.dart';
import 'package:speed/components/shakeTransition.dart';
import 'package:speed/controllers/login_controller.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (_) => Background(
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
                  // widget creado para animacion
                  ShakeTransition(
                    axis: Axis.vertical,
                    duration: Duration(
                      milliseconds: 2500,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/login.svg',
                      height: size.height > 450 ? size.height * 0.3 : 200,
                    ),
                  ),
                  Form(
                    key: _.formKey,
                    child: BoxForm2(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // titulo form
                          ShakeTransition(
                            duration: Duration(milliseconds: 3000),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  'Inicia sesi??n como ' + _.tipeUser(),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: ShakeTransition(
                              axis: Axis.vertical,
                              duration: Duration(
                                milliseconds: 1500,
                              ),
                              typeAnimation: Curves.easeIn,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // el widget creado lo reutilizamos
                                  InputControl(
                                    controlador: _.emailController,
                                    hint: 'Email',
                                    icon: FontAwesomeIcons.solidEnvelope,
                                    validar: (value) => value.isEmpty
                                        ? 'El email no puede estar en blanco'
                                        : ((!GetUtils.isEmail(value))
                                            ? 'Formato de email invalido'
                                            : null),
                                    // onSaved: (value) => _email = value,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InputControl2(
                                    controlador2: _.passwordController,
                                    hint: 'Contrase??a',
                                    validar: (value) => value.isEmpty
                                        ? 'La contrase??a no puede estar en blanco'
                                        : ((value.length < 6)
                                            ? 'La contrase??a debe tener almenos 6 caracteres'
                                            : null),
                                    // onSaved: (value) => _password = value,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ShakeTransition2(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Button(
                                  funcion: () async {
                                    await _.loginEmailPassword(context);
                                  },
                                  texto: 'Login',
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      //tamanBox: 0.47,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ShakeTransition(
                    child: ActionAccess(
                      typeAnimation: Curves.fastOutSlowIn,
                      text: 'No tienes una cuenta ?',
                      textLink: 'Registrate',
                      funcion: () => _.goRegister(),
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
          child: child,
        ),
      ),
    );
  }
}
