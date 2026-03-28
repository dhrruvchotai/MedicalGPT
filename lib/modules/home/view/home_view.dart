import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/home_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/typing_indicator.dart';
import '../../drawer/view/drawer_view.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/attachment_popup.dart';
import 'widgets/empty_chat_state.dart';
import 'widgets/bottom_input_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              height: AppSizes.appBarHeight,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Menu icon (Lucide)
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: Icon(
                        LucideIcons.menu,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  // Title
                  Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.appName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  // User avatar
                  Obx(
                    () {
                      final photoUrl = authService.currentUser.value.photoUrl;
                      final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;
                      final isLocalFile = hasPhoto && !photoUrl.startsWith('http');

                      ImageProvider? imageProvider;
                      if (hasPhoto) {
                        if (isLocalFile) {
                          imageProvider = FileImage(File(photoUrl));
                        } else {
                          imageProvider = CachedNetworkImageProvider(photoUrl);
                        }
                      }

                      return GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.profile),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkDivider
                                  : AppColors.border,
                              width: 2,
                            ),
                            image: imageProvider != null
                                ? DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: !hasPhoto
                              ? Center(
                                  child: Text(
                                    authService.currentUser.value.initials,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Chat area
            Expanded(
              child: Stack(
                children: [
                  // Main chat content
                  Obx(() {
                    if (controller.messages.isEmpty) {
                      return const EmptyChatState();
                    }
                    return ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.paddingM,
                      ),
                      itemCount: controller.messages.length +
                          (controller.isTyping.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.messages.length &&
                            controller.isTyping.value) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: AppSizes.paddingL,
                              bottom: AppSizes.paddingM,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/svg/logo.svg',
                                      width: 16,
                                      height: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const TypingIndicator(),
                              ],
                            ),
                          );
                        }
                        return ChatBubble(
                          message: controller.messages[index],
                          isNew: index == controller.messages.length - 1,
                        );
                      },
                    );
                  }),
                  // Attachment popup overlay
                  const AttachmentPopup(),
                ],
              ),
            ),
            // Bottom input bar
            const BottomInputBar(),
          ],
        ),
      ),
    );
  }
}
