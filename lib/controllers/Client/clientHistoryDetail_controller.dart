import 'package:get/get.dart';
import 'package:speed/Models/driver.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/controllers/Driver/driver_controller.dart';
import 'package:speed/controllers/Providers/travelHistory_provider.dart';

class ClientHistoryDetailController extends GetxController {
  String idTravelHistory;
  TravelHistory travelHistory;
  Driver driver;

  @override
  void onInit() {
    super.onInit();
    idTravelHistory = Get.arguments as String;
    getTravelHistory();
  }

  void getTravelHistory() async {
    travelHistory = await TravelHistoryProvider().getById(idTravelHistory);
    getDriverInfo(travelHistory.idDriver);
  }

  void getDriverInfo(String id) async {
    driver = await DriverController().getById(id);
    update();
  }
}
