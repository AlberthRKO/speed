import 'package:get/get.dart';
import 'package:speed/controllers/login_controller.dart';
import 'package:speed/screen/select_page.dart';

class SplashController extends GetxController {
  // Funcion que se ejecuta cuando se cargan todos los widgets en la app
  @override
  void onReady() async {
    super.onReady();
    Future.delayed(
      Duration(seconds: 3),
      () {
        // preguntamos si hay un usuario logeado
        LoginController().isLogin();
        // avanzamos a la pagina y eliminamos la anterior osea esta
        Get.offAll(
          () => SelectUSer(),
          transition: Transition.zoom,
        );
      },
    );
  }
}
