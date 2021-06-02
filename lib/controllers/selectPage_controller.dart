import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/screen/login_screen.dart';

class SelectUserController extends GetxController {
  final appData = GetStorage();
  bool get isDark2 => appData.read('darkmode');

  void goLogin(String typeUser) {
    // recibimos el tipo de user y lo guardamos
    saveTypeUser(typeUser);
    print(appData.read('typeUser'));
    print(appData.read('darkmode'));
    Get.to(
      () => Login(),
      transition: Transition.fadeIn,
    );
  }

  // guardamos el tupo de usuario en get storage
  void saveTypeUser(String typeUser) {
    appData.write('typeUser', typeUser);
  }

  void mostrar() {
    print(appData.read('typeUser'));
  }
}
