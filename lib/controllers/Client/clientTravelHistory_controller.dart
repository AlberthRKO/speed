import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:speed/Models/travelHistory.dart';
import 'package:speed/controllers/Providers/travelHistory_provider.dart';
import 'package:speed/screen/Client/clientHistoryDetail_screen.dart';

class ClientTravelHistoryController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    update();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User getUser() {
    return _auth.currentUser;
  }

  Future<List<TravelHistory>> getAll() async {
    return await TravelHistoryProvider().getByIdClient(getUser().uid);
  }

  void goTravelDetail(String id) {
    Get.to(
      () => ClientHistoryDetail(),
      transition: Transition.fade,
      arguments: id,
    );
  }
}
