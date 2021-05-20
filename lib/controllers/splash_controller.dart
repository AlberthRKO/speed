import 'package:get/get.dart';
import 'package:speed/screen/select_page.dart';

class SplashController extends GetxController {
  // Funcion que se ejecuta cuando se cargan todos los widgets en la app
  @override
  void onReady() {
    super.onReady();
    Future.delayed(
      Duration(seconds: 3),
      () {
        // avanzamos a la pagina y eliminamos la anterior osea esta
        Get.off(
          () => SelectRol(),
          transition: Transition.upToDown,
        );
      },
    );
  }
}
