

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderNotifier extends ChangeNotifier {
  final SharedPreferences? prefs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final BuildContext context;

  CreateOrderNotifier({required this.context, required TickerProvider vsync, required this.prefs});


}