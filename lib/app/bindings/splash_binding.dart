import 'package:get/get.dart';
import '../../modules/splash/controller/splash_controller.dart';
import '../../data/services/storage_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
    // Ensure StorageService is available
    if (!Get.isRegistered<StorageService>()) {
      Get.put(StorageService(), permanent: true);
    }
  }
}
