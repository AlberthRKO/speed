import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/controllers/login_controller.dart';
import 'package:speed/screen/select_page.dart';

class SplashController extends GetxController {
  final appData = GetStorage();
  // Funcion que se ejecuta cuando se cargan todos los widgets en la app
  @override
  void onReady() async {
    super.onReady();
    String notifi = appData.read('isNotification');
    Future.delayed(
      Duration(seconds: 3),
      () {
        // preguntamos si hay un usuario logeado
        if (notifi != 'true') {
          LoginController().isLogin();
          // avanzamos a la pagina y eliminamos la anterior osea esta
          Get.offAll(
            () => SelectUSer(),
            transition: Transition.zoom,
          );
        }
      },
    );
  }
}
