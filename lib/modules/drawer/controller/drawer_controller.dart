import 'package:get/get.dart';
import '../../../data/models/chat_history_model.dart';
import '../../../data/services/chat_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/controller/home_controller.dart';

class DrawerController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  final RxList<ChatHistoryModel> chatHistory = <ChatHistoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    isLoading.value = true;
    chatHistory.value = _chatService.getChatHistory();
    isLoading.value = false;
  }

  void startNewChat() {
    Get.back(); // Close drawer first
    if (Get.currentRoute != AppRoutes.home) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      // Already on home, just reset chat state
      final homeController = Get.find<HomeController>();
      homeController.startNewChat();
    }
  }

  void openChat(String chatId) {
    Get.back(); // Close drawer first
    if (Get.currentRoute != AppRoutes.home) {
      Get.offAllNamed(AppRoutes.home);
      // After navigation, load the chat
      Future.delayed(const Duration(milliseconds: 300), () {
        final homeController = Get.find<HomeController>();
        homeController.loadChat(chatId);
      });
    } else {
      final homeController = Get.find<HomeController>();
      homeController.loadChat(chatId);
    }
  }

  Future<void> deleteChat(String id) async {
    await _chatService.deleteChat(id);
    loadHistory();
  }
}
