import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit_lite/init.dart';
import 'package:flutter/src/widgets/image.dart' as img;
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
      home: AnyScreen(),
    );
  }
}

class AnyScreen extends StatefulWidget {
  const AnyScreen({super.key});

  @override
  State<AnyScreen> createState() => _AnyScreenState();
}

class _AnyScreenState extends State<AnyScreen> {

  void _showBottomSheet() {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30),bottom: Radius.circular(30)),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30),bottom: Radius.circular(30)),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        height: 5,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SdekWindow(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:GestureDetector(
              onTap: _showBottomSheet,
              child: Container(
                  height: 50,
                  width: 260,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  child: Center(child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Text('Выбрать пункт выдачи'),
                      SizedBox(width: 10,),
                      img.Image.asset('assets/sdek.png',width: 60,),
                    ],
                  ),
                  )
              )
          ),
        )
    );
  }
}