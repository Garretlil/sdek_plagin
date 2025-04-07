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
        builder: (context, sdekWindow, child) {
          sdekWindow.onPlacemarkTap = (pointData) {
            _showBottomSheet(pointData);
          };
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned.fill(
                  child: YandexMap(
                    onMapCreated: (mapWindow) {
                      sdekWindow.onMapCreated(mapWindow);
                    },
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
          );
        },
      ),
    );
  }
  void temp(){}
  void _showBottomSheet(PointPlaceMark pointData) {
    final text=split(pointData.description);
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
            initialChildSize: 0.7,
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
                  Text('Пункт СДЭК ${text[0]}'),
                  Text(text[1],style: TextStyle(fontWeight: FontWeight.w800 ),),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child:
                    Column(children: [
                      Row(children:
                        [
                          Icon(Icons.language,color: Colors.green,),
                          SizedBox(width: 10,),
                          Text('ст. м.${pointData.metro}'),
                          SizedBox(width: 5,),
                          Icon(Icons.circle,size: 10,color: Colors.orange,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(children:
                      [
                        Icon(Icons.check_box_outline_blank,color: Colors.green,),
                        SizedBox(width: 10,),
                        Text('Вес: до 100 кг')
                      ],
                      ),
                   ]
                  )
                 ),
                  GestureDetector(
                    onTap: ()=>temp(),
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
