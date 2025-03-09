import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdek_plagin/SdekWindowNotifier.dart';
import 'package:yandex_maps_mapkit_lite/yandex_map.dart';

class SdekWindow extends StatefulWidget {
  const SdekWindow({super.key});
  @override
  State<SdekWindow> createState() => _SdekWindowState();
}

class _SdekWindowState extends State<SdekWindow> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SdekWindowNotifier(),
      child: Consumer<SdekWindowNotifier>(
        builder: (context, sdekWindow, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                child: YandexMap(
                  onMapCreated: sdekWindow.onMapCreated,
                ),
              ),
              Positioned(
                bottom: 330,
                right: 10,
                child: Column(
                  children: [
                    _buildButton(Icons.add, () => sdekWindow.changeZoom(true)),
                    SizedBox(height: 15),
                    _buildButton(Icons.remove, () => sdekWindow.changeZoom(false)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Icon(icon, size: 30, color: Colors.black
        ),
      ),
    );
  }
}
