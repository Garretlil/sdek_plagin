import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/init.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

import 'SdekWindow.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initMapkit(apiKey: '1803e53b-9ddc-4b80-835e-2e45189b8218');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const SdekWindow(),
    );
  }
}

