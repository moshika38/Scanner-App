import 'package:shared_preferences/shared_preferences.dart';

class PathServices {
  // save location
  static Future<void> saveLocation(String location) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("location", location);
  }

  // get location
  static Future<String> getLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("location") ?? "/storage/emulated/0/Download";
  }
}
