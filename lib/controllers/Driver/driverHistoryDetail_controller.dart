import 'package:get/get.dart';
import 'package:speed/Models/client.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/controllers/Client/cliente_controller.dart';
import 'package:speed/controllers/Providers/travelHistory_provider.dart';

class DriverHistoryDetailController extends GetxController {
  String idTravelHistory;
  TravelHistory travelHistory;
  Client client;

  @override
  void onInit() {
    super.onInit();
    idTravelHistory = Get.arguments as String;
    getTravelHistory();
  }

  void getTravelHistory() async {
    travelHistory = await TravelHistoryProvider().getById(idTravelHistory);
    getClientInfo(travelHistory.idClient);
  }

  void getClientInfo(String id) async {
    client = await ClientController().getById(id);
    update();
  }
}
