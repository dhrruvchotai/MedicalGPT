import 'package:get/get.dart';
import '../../modules/home/controller/home_controller.dart';
import '../../modules/drawer/controller/drawer_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DrawerController>(() => DrawerController());
  }
}
