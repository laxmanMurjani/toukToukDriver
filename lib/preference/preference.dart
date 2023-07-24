import 'package:shared_preferences/shared_preferences.dart';

class Database {
  static const String seenOnBoarding = "setSeenLocationAlertDialog";

  static setSeenLocationAlertDialog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setSeenLocationAlertDialog', true);
  }


  static setOverlayPermission() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setOverlayPermission', true);
  }


  static getOverlayPermission() async {

  }
}
