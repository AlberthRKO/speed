import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/avatar.dart';
import 'package:speed/components/background.dart';
import 'package:speed/components/button.dart';
import 'package:speed/components/inputForm.dart';
import 'package:speed/components/shakeTransition.dart';
import 'package:speed/controllers/Driver/driverEditProfile_controller.dart';
import 'package:speed/screen/login_screen.dart';

class DriverEditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<DriverEditProfileController>(
      init: DriverEditProfileController(),
      builder: (_) => Background(
        taman: size.width > 450 ? 800 : 650,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  ReturnBack(),
                  /* ShakeTransition(
                    axis: Axis.vertical,
                    duration: Duration(milliseconds: 2500),
                    child: SvgPicture.asset(
                      'assets/images/register.svg',
                      height: size.height > 450 ? size.height * 0.3 : 200,
                    ),
                  ), */
                  Form(
                    key: _.formKey,
                    child: BoxForm2(
                      child: Column(
                        children: [
                          ShakeTransition(
                            duration: Duration(milliseconds: 3000),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Editar perfil',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(
                                  height: 10,
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
                                  GestureDetector(
                                    onTap: () => _.showAlertDialog(context),
                                    child: Obx(
                                      () => _.selectImagePath.value == ''
                                          ? Avatar(
                                              backgroundImage: _
                                                          .driver?.image !=
                                                      null
                                                  ? NetworkImage(
                                                      _.driver?.image)
                                                  : AssetImage(_
                                                          .imageFile?.path ??
                                                      'assets/images/yo.png'),
                                            )
                                          : Avatar(
                                              backgroundImage: FileImage(
                                                File(_.selectImagePath.value),
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _.driver?.email ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  InputControl(
                                    controlador: _.nameController,
                                    hint: 'Nombre',
                                    icon: FontAwesomeIcons.solidUser,
                                    validar: (value) => value.isEmpty
                                        ? 'El nombre no puede estar en blanco'
                                        : ((value.length < 15)
                                            ? 'El nombre debe tener almenos 15 caracteres'
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InputControl(
                                    controlador: _.modeloController,
                                    hint: 'Modelo',
                                    icon: FontAwesomeIcons.carSide,
                                    validar: (value) => value.isEmpty
                                        ? 'El modelo no puede estar en blanco'
                                        : ((value.length < 6)
                                            ? 'El modelo debe tener almenos 6 caracteres'
                                            : null),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InputControl(
                                    controlador: _.placaController,
                                    hint: 'Placa',
                                    icon: FontAwesomeIcons.car,
                                    validar: (value) => value.isEmpty
                                        ? 'La placa no puede estar en blanco'
                                        : ((value.length < 8)
                                            ? 'El numero de placa debe tener almenos 8 caracteres'
                                            : null),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ShakeTransition2(
                            child: Button(
                              funcion: () => _.actualizar(context),
                              texto: 'Actualizar',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
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
