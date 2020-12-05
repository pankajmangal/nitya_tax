import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static saveUser(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future<String> getLoggedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('token')) {
      return prefs.getString('token');
    }

    return null;
  }

  static deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
