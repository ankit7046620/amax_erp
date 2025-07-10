import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  /// Private constructor
  StorageService._internal();

  /// Singleton instance
  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._internal();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Keys
  static const String onboardingSeenKey = 'onboarding_seen';

  // Set onboarding as seen
  Future<void> setOnboardingSeen(bool value) async {
    await _prefs?.setBool(onboardingSeenKey, value);
  }

  // Get onboarding seen status
  bool get isOnboardingSeen => _prefs?.getBool(onboardingSeenKey) ?? false;

  // Generic methods
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
