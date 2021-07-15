import 'package:get/get.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/controllers/Providers/travelHistory_provider.dart';
import 'package:speed/screen/Driver/homeDriver_screen.dart';
import 'package:speed/utils/snackBar.dart';

class DriverTravelCalificationController extends GetxController {
  String idTravelHistory;
  TravelHistory travelHistory;

  double calification;

  @override
  void onInit() {
    super.onInit();
    idTravelHistory = Get.arguments as String;
  }

  @override
  void onReady() {
    super.onReady();
    getTravelHistory();
  }

  void getTravelHistory() async {
    travelHistory = await TravelHistoryProvider().getById(idTravelHistory);
    update();
  }

  void calificate() async {
    if (calification == null) {
      snackError(
        title: 'Error Calificación',
        msg: 'Debe asignar una calificación',
      );
      return;
    }
    if (calification == 0) {
      snackError(
        title: 'Error Calificación',
        msg: 'La calificación minima debe ser 1',
      );
      return;
    }
    Map<String, dynamic> data = {
      'calificationClient': calification,
    };
    await TravelHistoryProvider().actualizar(data, idTravelHistory);
    Get.offAll(
      () => HomeDriver(),
      transition: Transition.size,
    );
  }
}
