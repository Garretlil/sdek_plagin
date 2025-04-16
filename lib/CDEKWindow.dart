import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdek_plagin/MetroStation.dart';
import 'package:sdek_plagin/SdekWindowNotifier.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'createOrderScreen.dart';

class CDEKWindow extends StatefulWidget {
  const CDEKWindow({super.key});

  @override
  State<CDEKWindow> createState() => _CDEKWindowState();
}

class _CDEKWindowState extends State<CDEKWindow> {
  late final YandexMapController _mapController;
  var _mapZoom = 0.0;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CDEKWindowNotifier(),
      child: Consumer<CDEKWindowNotifier>(
        builder: (context, CDEKWindow, child) {
          CDEKWindow.onPlacemarkTap = (pointData) {
            _showBottomSheet(pointData,CDEKWindow.stations);
          };
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned.fill(
                  child: YandexMap(
                    onMapCreated: (mapWindow) {
                      CDEKWindow.onMapCreated(mapWindow);
                    },
                    onCameraPositionChanged: (cameraPosition, _, __) {
                      setState(() {
                        _mapZoom = cameraPosition.zoom;
                      });
                    },
                    mapObjects: CDEKWindow.clusterizedCollection != null
                        ? [CDEKWindow.clusterizedCollection!]
                        : [],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  void temp(){}
  PageRouteBuilder customPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
  void _showBottomSheet(PointPlaceMark pointData, List<MetroStation>? stations) {
    final text=split(pointData.description);
    final targetStations= getMatchingStations(stations!,pointData.metro);
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
            initialChildSize: 0.5,
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
                  Text(pointData.type=='PVZ'? 'Пункт выдачи СДЭК' : 'Постамат СДЭК'),
                  Text(text[1],style: TextStyle(fontWeight: FontWeight.w800 ),),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child:
                      Column(children: [
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.green),
                            SizedBox(width: 10),
                            Text(pointData.metro),
                            SizedBox(width: 5),
                            for (var station in targetStations)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(Icons.circle, size: 10, color: station.color),
                              ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.access_time_outlined, color: Colors.green),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                pointData.workTime,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ]
                      )
                  ),
                  SizedBox(height: 90,),
                  GestureDetector(
                    onTap: ()=>
                        Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CreateOrderScreen(pointData: pointData)),
                     ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.green
                      ),
                      width: 200,
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.get_app_sharp,size: 25,color: Colors.white,),
                          SizedBox(height: 5,),
                          Text('Доставить сюда',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
  List<String> split(String str) {
    int index = str.indexOf(',');
    List<String> parts;
    if (index != -1) {
      parts = [str.substring(0, index), str.substring(index + 1)];
    } else {
      parts = [str];
    }
    return parts;
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