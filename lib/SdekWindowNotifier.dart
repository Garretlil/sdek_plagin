import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/image.dart' as mapkitImage;
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as mapkit;

class PointPlacemark{

  final double latitude;
  final double longitude;
  final String description;
  final String adress;
  PointPlacemark({
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.adress
  });
}

class SdekWindowNotifier extends ChangeNotifier {
  mapkit.MapWindow? mapWindow;
  double? zoom;
  mapkit.Point currentPosition = const mapkit.Point(latitude: 59.935493, longitude: 30.327392);
  final cameraCallback = mapkit.MapCameraCallback(onMoveFinished: (isFinished) {});
  late List<PointPlacemark> placemarks=[
    PointPlacemark(
        latitude: 55.76,
        longitude: 37.63,
        description: 'Пункт выдачи',
        adress:'Кутузовский проспект д32'),
  ];
  void onMapCreated(mapkit.MapWindow mapWindow) {
    this.mapWindow = mapWindow;
    zoom = mapWindow.map.cameraPosition.zoom;
    for (var item in placemarks) {
      final placemark= mapWindow.map.mapObjects.addPlacemark()
         ..geometry= mapkit.Point(
             latitude: item.latitude,
             longitude: item.longitude
         )
         ..setText(item.description)
         ..setTextStyle(
             const mapkit.TextStyle(
               size: 8.0,
               color: Colors.black,
               outlineColor: Colors.white,
               placement: mapkit.TextStylePlacement.Right,
               offset: 2.0,
               offsetFromIcon: true
            )
         )
        ..setIcon(mapkitImage.ImageProvider.fromImageProvider(
            const AssetImage("assets/sdek_icon.png"))
        )
        ..setIconStyle(mapkit.IconStyle(scale: 0.5));
    }
    mapWindow.map.nightModeEnabled=false;
    if (kDebugMode) {
      print("карта создана: начальный zoom: $zoom");
    }
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
