import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String _keyTheme = 'isDarkMode';
  static const String _keyOnboarding = 'hasSeenOnboarding';
  static const String _keyUser = 'userData';
  static const String _keyUsersDb = 'usersDb';

  late SharedPreferences _prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  // Theme
  bool get isDarkMode => _prefs.getBool(_keyTheme) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyTheme, value);
  }

  // Onboarding
  bool get hasSeenOnboarding => _prefs.getBool(_keyOnboarding) ?? false;

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_keyOnboarding, value);
  }

  // User Data (lightweight, using SP for quick access)
  String? get userDataJson => _prefs.getString(_keyUser);

  Future<void> saveUserData(String json) async {
    await _prefs.setString(_keyUser, json);
  }

  Future<void> clearUserData() async {
    await _prefs.remove(_keyUser);
  }

  // Users Database (Local persistence for all mock/manual accounts)
  String? get usersDbJson => _prefs.getString(_keyUsersDb);

  Future<void> saveUsersDb(String json) async {
    await _prefs.setString(_keyUsersDb, json);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
