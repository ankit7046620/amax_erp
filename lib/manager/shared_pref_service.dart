import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();
  late SharedPreferences _prefs;

  factory SharedPrefService() {
    return _instance;
  }

  SharedPrefService._internal();

  /// Call this before using any other method (in main or on app start)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Setters
  Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  Future<void> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  Future<void> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  // Getters
  String? getString(String key) => _prefs.getString(key);

  int? getInt(String key) => _prefs.getInt(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  bool? getBool(String key) => _prefs.getBool(key);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Remove key
  Future<void> remove(String key) async => await _prefs.remove(key);

  // Clear all data
  Future<void> clearAll() async => await _prefs.clear();
}
