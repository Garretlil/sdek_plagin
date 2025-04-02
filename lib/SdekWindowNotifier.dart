import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/image.dart' as mapkitImage;
import 'package:yandex_maps_mapkit_lite/mapkit.dart' as mapkit;
import 'CdekApi.dart';
import 'CdekAuth.dart';
import 'CustomClusterPainter.dart';
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
  List<PointPlaceMark> placemarks = [];
  mapkit.ClusterizedPlacemarkCollection? clusterizedCollection;

  SdekWindowNotifier() {
    auth = CdekAuth(clientId: clientId, clientSecret: clientSecret);
    api = CdekApi(auth);
  }

  late final GeoLocator geoLocator;
  mapkit.MapWindow? mapWindow;
  double? zoom;
  mapkit.Point currentPosition = const mapkit.Point(latitude: 59.935493, longitude: 30.327392);
  final cameraCallback = mapkit.MapCameraCallback(onMoveFinished: (isFinished) {});

  Future<void> _loadPoints() async {
    try {
      points = await api.fetchDeliveryPoints();
      placemarks = points.map((point) => PointPlaceMark(
        latitude: point.latitude,
        longitude: point.longitude,
        description: point.name,
        adress: point.address,
      )).toList();
    } catch (e) {
      print('Ошибка загрузки пвз: $e');
    }
  }

  Future<void> onMapCreated(mapkit.MapWindow mapWindow) async {
    await _loadPoints();
    this.mapWindow = mapWindow;
    zoom = mapWindow.map.cameraPosition.zoom + 8;

    final clusterIcon = mapkitImage.ImageProvider.fromImageProvider(
      const AssetImage("assets/sdek_icon.png"),
    );

    clusterizedCollection = mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(
      ClusterListenerImpl(),
    );

    final icon = mapkitImage.ImageProvider.fromImageProvider(
      const AssetImage("assets/sdek_icon.png"),
    );

    for (var placemark in placemarks) {
      clusterizedCollection!.addPlacemark()
        ..geometry = mapkit.Point(
          latitude: placemark.latitude,
          longitude: placemark.longitude,
        )
        ..setIcon(icon);
    }

    clusterizedCollection!.clusterPlacemarks(clusterRadius: 60.0, minZoom: 5);

    print("Кластеры добавлены");
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
    zoom = newZoom;
    notifyListeners();
  }
}


class ClusterListenerImpl implements mapkit.ClusterListener {
  @override
  void onClusterAdded(mapkit.Cluster cluster) async {
    final iconBytes = await ClusterIconPainter(cluster.placemarks.length).getClusterIconBytes();
    final clusterIcon = mapkitImage.ImageProvider.fromImageProvider(
      MemoryImage(iconBytes),
    );

    cluster.appearance.setIcon(clusterIcon);
  }
}


class ClusterTapListenerImpl implements mapkit.ClusterTapListener {
  @override
  bool onClusterTap(mapkit.Cluster cluster) {
    print("Клик по кластеру с ${cluster.placemarks.length} объектами");
    return true;
  }
}


