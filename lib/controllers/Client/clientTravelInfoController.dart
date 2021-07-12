import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speed/Models/direcction_model.dart';
import 'package:speed/Models/prices.dart';
import 'package:speed/api/environment.dart';
import 'package:speed/controllers/Providers/googleDirections.dart';
import 'package:speed/controllers/Providers/prices_provider.dart';
import 'package:speed/screen/Client/clienteTravelRequest_screen.dart';
import 'package:speed/theme/themeChange.dart';

class ClientTravelInfoController extends GetxController {
  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;
  String latitude;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;
  Directions info;

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> argumentos = Get.arguments;
    from = argumentos['from'];
    to = argumentos['to'];
    fromLatLng = argumentos['fromLatLng'];
    toLatLng = argumentos['toLatLng'];
    respuestita();
    // print('argumentos from: $from');
  }

  @override
  void onReady() async {
    super.onReady();
    loadStyle();
    fromMarker = await createMarkerImage('assets/images/pinInicio.png');
    toMarker = await createMarkerImage('assets/images/pinLlegada.png');

    // animatePosition();
    // respuestita();
  }

  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();
  String _darkMap;
  String _lightMap;

  // StreamSubscription<Position> _streamPosition;

  // Variables para marcadores
  // lista de marcadores
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // Variables de trazado de ruta info
  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  String distancia;
  String tiempo;
  // variables para precio
  double minTotal;
  double maxTotal;

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(-19.0394279, -65.2554989),
    zoom: 17,
  );

  void onMapCreate(GoogleMapController controller) async {
    _mapController.complete(controller);
    setMapStyle();
    await setPolylines();
  }

  Future loadStyle() async {
    _darkMap = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMap = await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future setMapStyle() async {
    final controller = await _mapController.future;
    if (TemaProvider().isDark) {
      controller.setMapStyle(_darkMap);
    } else {
      controller.setMapStyle(_lightMap);
    }
  }
  /* --------------------------
  Seccion de trazado de ruta
  ---------------------------*/

  Future<void> setPolylines() async {
    // definimos las coordenadas de los puntos
    PointLatLng pointFromLatLng =
        PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng =
        PointLatLng(toLatLng.latitude, toLatLng.longitude);

    // pasamos las coordenadas para que devuelva un resultado
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS, pointFromLatLng, pointToLatLng);

    // Recorremos los puntos del resultado para pintarlo
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    // definimos como sera la ruta pasandole la lista del for
    Polyline polyline = Polyline(
      polylineId: PolylineId('pol'),
      color: TemaProvider().isDark ? Color(0XFFE7D42F) : Color(0XFF3B4661),
      points: points,
      width: 3,
    );
    // lo definimos en la variable global
    polylines.add(polyline);

    addMarker('from', fromLatLng.latitude, fromLatLng.longitude, 'Origen', from,
        fromMarker);
    addMarker(
        'to', toLatLng.latitude, toLatLng.longitude, 'Destino', to, toMarker);

    update();
  }

  Future animatePosition() async {
    final controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: fromLatLng,
            zoom: 15,
          ),
        ),
      );
    }
  }

  Future animatePosition2() async {
    final controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(info.limites, 115),
      );
    }
  }

  void origenPos() async {
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: fromLatLng,
          zoom: 16.5,
          tilt: 50.0,
        ),
      ),
    );
  }

  void destinoPos() async {
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: toLatLng,
          zoom: 16.5,
          tilt: 50.0,
        ),
      ),
    );
  }

  // metodo para crear un marker recibira la ruta de la imagen
  Future<BitmapDescriptor> createMarkerImage(String path) async {
    // creamos una configuracion de imagen para pasarlo al bitmap
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  // funcion para añadir marcador
  void addMarker(
    String markerId,
    double lat,
    double log,
    String title,
    String content,
    BitmapDescriptor icon,
  ) {
    // una ves creado un marquer hacemos que se añada a la lista
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: icon,
      position: LatLng(lat, log),
      infoWindow: InfoWindow(
        title: title,
        snippet: content,
      ),
    );

    markers[id] = marker;
  }

  Future<void> respuestita() async {
    info = await GoogleDirection().getDirecctionInfo(fromLatLng.latitude,
        fromLatLng.longitude, toLatLng.latitude, toLatLng.longitude);
    distancia = info.totalDistance;
    tiempo = info.totalDuration;
    calcularPrice();
    animatePosition2();
    update();
  }

  /* Seccion de Precios */

  void calcularPrice() async {
    Prices prices = await PricesProvider().getAll();
    double kmValue = double.parse(distancia.split(" ")[0]) * prices.km;
    double minvalue = double.parse(tiempo.split(" ")[0]) * prices.min;

    double total = kmValue + minvalue;
    minTotal = total - 0.5;
    maxTotal = total + 0.5;
    maxTotal = maxTotal.toPrecision(2);
    minTotal = minTotal.toPrecision(2);
    update();
  }

  void goRequestSoli() {
    Get.to(
      () => ClientTravelRequest(),
      transition: Transition.downToUp,
      arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
      },
    );
  }
}
