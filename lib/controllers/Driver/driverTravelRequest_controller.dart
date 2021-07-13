import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';

class DriverTravelRequestController extends GetxController {
  String from;
  String to;
  String idClient;

  final appData = GetStorage();
  // bool get isDark2 => appData.read('darkmode');

  Client client;

  @override
  void onReady() {
    super.onReady();
    appData.write('isNotification', 'false');
    Map<String, dynamic> argumentos = Get.arguments;
    from = argumentos['origen'];
    to = argumentos['destino'];
    idClient = argumentos['idClient'];
    print('argumentoooooos $from');
    getClientInfo();
  }

  void getClientInfo() async {
    client = await ClientController().getById(idClient);
    update();
  }
}
