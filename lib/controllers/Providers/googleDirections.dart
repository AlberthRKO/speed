import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:speed/Models/direcction_model.dart';
import 'package:speed/api/environment.dart';

class GoogleDirection extends GetxController {
  static const String _baseURL =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio;
  GoogleDirection({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirecctionInfo(
      double fromLat, double fromLng, double toLat, double toLng) async {
    final respuesta = await _dio.get(
      _baseURL,
      queryParameters: {
        'origin': '$fromLat,$fromLng',
        'destination': '$toLat,$toLng',
        'key': Environment.API_KEY_MAPS,
        'traddic_model': 'best_guess',
        'departure_time': DateTime.now().microsecondsSinceEpoch.toString(),
        'mode': 'driving',
        'transit_routing_preferences': 'less_driving',
      },
    );
    if (respuesta.statusCode == 200) {
      print(respuesta.data);
      return Directions.fromMap(respuesta.data);
    } else {
      return null;
    }
  }
}
