import 'package:shared_preferences/shared_preferences.dart';

void saveStorage(String key, String value) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.setString(key, value);
}

Future<String> getStorage(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  var result = storage.getString(key) ?? '';

  return result.toString();
}

void removeStorage(String key) async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  storage.remove(key);
}
