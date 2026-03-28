import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/auth_service.dart';

class SplashController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final AuthService _auth = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (_storage.hasSeenOnboarding) {
      if (_auth.isLoggedIn.value) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.signIn);
      }
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
