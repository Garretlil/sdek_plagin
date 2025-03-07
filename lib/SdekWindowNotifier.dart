import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:yandex_maps_mapkit_lite/image.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';

class SdekWindowNotifier extends ChangeNotifier {
  MapWindow? mapWindow;
  double? zoom;
  Point currentPosition = const Point(latitude: 59.935493, longitude: 30.327392);
  final cameraCallback = MapCameraCallback(onMoveFinished: (isFinished) {
    // Handle camera move finished ...
  });
  void addPlacemark(MapWindow mapWindow) {

  }

  void onMapCreated(MapWindow mapWindow) {
    this.mapWindow = mapWindow;
    zoom = mapWindow.map.cameraPosition.zoom;
    if (kDebugMode) {
      print("карта создана: начальный zoom: $zoom");
    }
    currentPosition = mapWindow.map.cameraPosition.target;

    notifyListeners();
  }
  void setMapWindow(MapWindow window) {
    currentPosition = mapWindow!.map.cameraPosition.target;
  }

  void changeZoom(bool increase) async {
    double newZoom = (zoom! + (increase ? 1 : -1)).clamp(
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
      CameraPosition(
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
