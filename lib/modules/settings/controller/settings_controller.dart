import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  late RxBool isDarkMode;
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode = _storage.isDarkMode.obs;
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    await _storage.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  String get appVersion => '1.0.0';
}
