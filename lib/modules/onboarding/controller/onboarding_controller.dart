import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../data/services/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  late PageController pageController;

  final RxInt currentPage = 0.obs;
  final int totalPages = 3;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void skip() {
    completeOnboarding();
  }

  Future<void> completeOnboarding() async {
    await _storage.setHasSeenOnboarding(true);
    Get.offAllNamed(AppRoutes.signIn);
  }

  bool get isLastPage => currentPage.value == totalPages - 1;
}
