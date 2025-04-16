
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sdek_plagin/SdekWindowNotifier.dart';
import 'package:sdek_plagin/UserOrderInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ConfirmationOrder.dart';
import 'createOrderNotifier.dart';

class CreateOrderScreen extends StatefulWidget{
  final PointPlaceMark pointData;
  const CreateOrderScreen({super.key, required this.pointData});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin{
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  late Future<SharedPreferences> _prefsFuture;

  @override
  void initState(){
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingFactor = screenWidth * 0.06;
    double titleSizeFactor = screenWidth * 0.06;
    double spacingFactor = screenHeight * 0.06;
    return FutureBuilder<SharedPreferences>(
      future: _prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator())); // Loading indicator
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          return ChangeNotifierProvider(
            create: (context) => CreateOrderNotifier(context: context, vsync: this, prefs: snapshot.data!),
            child: Consumer<CreateOrderNotifier>(
              builder: (context, registration, child) => Scaffold(
                backgroundColor: Colors.white,
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    paddingFactor * 1.2,
                                    paddingFactor * 2.4,
                                    paddingFactor, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap:()=> Navigator.pop(context),
                                            child: Icon(Icons.arrow_back_ios_new),
                                          ),
                                          Text(
                                            'Введите ваши имя и почту для оформления доставки',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: titleSizeFactor * 0.8,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inria Serif',
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          //Icon(Icons.place,color: Colors.green,size: 30,)
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: spacingFactor * 2),
                                    _buildTextField(registration.prefs?.getBool('LangParams') == true ? 'Name' : 'Имя', registration.nameController, snapshot.data!),
                                    SizedBox(height: spacingFactor * 0.27),
                                    _buildTextField('Email', registration.emailController, snapshot.data!),
                                    SizedBox(height: spacingFactor * 5),
                                    Center(
                                      child: GestureDetector(
                                        onTap: ()=>{
                                            UserOrderInfo.instance.init(
                                              fullName: 'Карл Фридрих Гаусс',
                                              email: 'gauss@example.com',
                                              phoneNumber: '+7 (900) 000-00-00',
                                              pointData: widget.pointData
                                            ),
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => const ConfirmationOrderScreen()),
                                        )},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                              color: Colors.green
                                          ),
                                          width: 300,
                                          height: 60,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              //Icon(Icons.get_app_sharp,size: 25,color: Colors.white,),
                                              //SizedBox(height: 5,),
                                              Text('Продолжить',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 22),)
                                            ],
                                          ),
                                        ),
                                      )
                                    ),
                                    SizedBox(height: spacingFactor),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          ),//
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
  Widget _buildTextField(String label, TextEditingController controller, SharedPreferences prefs) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade800, fontFamily: prefs.getBool('LangParams') == true ? 'Inria Serif' : 'Inria Serif'),
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white, width: 5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.white, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      ),
    );
  }
}