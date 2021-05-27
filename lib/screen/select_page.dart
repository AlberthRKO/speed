import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speed/components/navigator.dart';
import 'package:speed/components/shakeTransition.dart';
import 'package:speed/controllers/selectPage_controller.dart';
import 'package:speed/screen/login_screen.dart';

class SelectRol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: size.height * 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              width: 1100,
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/topWave.png',
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Speed',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SvgPicture.asset(
                    'assets/images/splash.svg',
                    width: 45,
                  ),
                ],
              ),
            ),
            contentRol(context, size),
          ],
        ),
      ),
    );
  }

  BoxDecoration estiloImagen(context) {
    return BoxDecoration(
      // color: Colors.red,
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).cardColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 6),
          blurRadius: 4,
        )
      ],
    );
  }

  Widget contentRol(context, size) {
    return Container(
      height: size.height,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Escoja su rol',
              style: Theme.of(context).textTheme.headline2,
            ),
            SizedBox(
              height: size.height * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // le ponemos un inkell para que cuando presione
                // nos mande a otra vista con el tap
                ShakeTransition2(
                  child: GetBuilder<SelectUser>(
                    init: SelectUser(),
                    builder: (_) => NavigatorLink(
                      funcion: () => _.goLogin('Client'),
                      child: Container(
                        height: size.height * 0.3,
                        width: 200,
                        decoration: estiloImagen(context),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 7,
                              child: SvgPicture.asset(
                                'assets/images/cliente.svg',
                                width: 160,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Cliente',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShakeTransition(
                  child: GetBuilder<SelectUser>(
                    init: SelectUser(),
                    builder: (_) => NavigatorLink(
                      funcion: () => _.goLogin('Driver'),
                      child: Container(
                        width: 200,
                        height: size.height * 0.3,
                        decoration: estiloImagen(context),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 7,
                              child: SvgPicture.asset(
                                'assets/images/conductor.svg',
                                width: 160,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Conductor',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
