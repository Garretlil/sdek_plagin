import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_maps_mapkit_lite/image.dart' as mapkitImage;
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as mapkit;
import 'CdekApi.dart';
import 'CdekAuth.dart';
import 'gps_module.dart';

class PointPlaceMark{
  final double latitude;
  final double longitude;
  final String description;
  final String adress;

  PointPlaceMark({
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.adress
  });

}

class SdekWindowNotifier extends ChangeNotifier {
  static const clientId = 'NYnDZhNexvHneGnk29cdGpZuAxwFot6J';
  static const clientSecret = 'RglJK9tAYIUUhP2Dt3NuBChjm7iESwkf';
  late final CdekAuth auth;
  late final CdekApi api;
  List<DeliveryPoint> points = [];
  List<PointPlaceMark> placemarks=[];
  SdekWindowNotifier() {
    auth = CdekAuth(clientId: clientId, clientSecret: clientSecret);
    api = CdekApi(auth);
    // _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      points = await api.fetchDeliveryPoints();
      placemarks = points.map((point) => PointPlaceMark(
        latitude: point.latitude,
        longitude: point.longitude,
        description: point.name,
        adress: point.address,
      )).toList();
      //notifyListeners();
    } catch (e) {
      print('Ошибка загрузки пвз: $e');
    }
  }

  late final GeoLocator geoLocator;
  mapkit.MapWindow? mapWindow;
  double? zoom;
  mapkit.Point currentPosition = const mapkit.Point(latitude: 59.935493, longitude: 30.327392);
  final cameraCallback = mapkit.MapCameraCallback(onMoveFinished: (isFinished) {});
  // late List<PointPlaceMark> placemarks=[
  //   PointPlaceMark(latitude: points[0].latitude,
  //       longitude: points[0].longitude,
  //       description: points[0].name,
  //       adress: points[0].address
  //   )
  //   PointPlaceMark(
  //       latitude: 55.76,
  //       longitude: 37.63,
  //       description: 'Пункт выдачи СДЭК',
  //       adress:'Кутузовский проспект д32'),
  //   PointPlaceMark(
  //       latitude: 55.66,
  //       longitude: 37.57,
  //       description: 'Пункт выдачи СДЭК',
  //       adress:'Кутузовский проспект д32'),
  //   PointPlaceMark(
  //       latitude: 55.56,
  //       longitude: 37.50,
  //       description: 'Пункт выдачи СДЭК',
  //       adress:'Кутузовский проспект д32'),
  // ];
  Future<void> onMapCreated(mapkit.MapWindow mapWindow) async {
    _loadPoints();
    await Future.delayed(Duration(seconds: 5));
    this.mapWindow = mapWindow;
    zoom = mapWindow.map.cameraPosition.zoom+8;

    geoLocator = GeoLocator();
    await geoLocator.setLocation();

    Position? position;
    try {
      position = await geoLocator.position;
    } catch (e) {
      return;
    }
    mapWindow.map.move(mapkit.CameraPosition(
      mapkit.Point(latitude: position!.latitude, longitude: position.longitude),
      zoom: zoom!,
      azimuth: 0.0,
      tilt: 0.0,
    ));
    for (var item in placemarks) {
      final placeMark = mapWindow.map.mapObjects.addPlacemark()
        ..geometry = mapkit.Point(
            latitude: item.latitude,
            longitude: item.longitude
        )
        ..setText('${item.description}\n${item.adress}')
        ..setTextStyle(
            const mapkit.TextStyle(
              size: 8.0,
              color: Colors.black,
              outlineWidth: 50,
              outlineColor: Colors.white,
              placement: mapkit.TextStylePlacement.Right,
              offset: 2.0,
              offsetFromIcon: true,
            )
        )
        ..setIcon(mapkitImage.ImageProvider.fromImageProvider(
            const AssetImage("assets/sdek_icon.png"))
        )
        ..setIconStyle(mapkit.IconStyle(scale: 0.5));
    }

    mapWindow.map.nightModeEnabled = false;
    print("карта создана: начальный zoom: $zoom");

    currentPosition = mapWindow.map.cameraPosition.target;

    notifyListeners();
  }


  void setMapWindow(mapkit.MapWindow window) {
    currentPosition = mapWindow!.map.cameraPosition.target;
  }

  void changeZoom(bool increase) async {
    double newZoom = (zoom! + (increase ? 0.7 : -0.7)).clamp(
      mapWindow!.map.cameraBounds.getMinZoom(),
      mapWindow!.map.cameraBounds.getMaxZoom(),
    );
    if (mapWindow == null || zoom == null) {
      if (kDebugMode) {
        print("карта не инициализирована");
      }
      return;
    }
    currentPosition = mapWindow!.map.cameraPosition.target;
    zoom = (zoom! + (increase ? 1 : -1)).clamp(2.0, mapWindow!.map.cameraBounds.getMaxZoom());
    if (kDebugMode) {
      print("изменяем zoom: $zoom");
    }
    mapWindow!.map.move(
      mapkit.CameraPosition(
        currentPosition,
        zoom: newZoom,
        azimuth: 0.0,
        tilt: 0.0,
      ),
    );
    zoom=newZoom;
    notifyListeners();
  }
}
