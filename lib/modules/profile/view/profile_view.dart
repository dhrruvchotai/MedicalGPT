import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/animated_press_button.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.profile,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isEditing.value
                  ? controller.saveProfile
                  : controller.toggleEdit,
              child: Text(
                controller.isEditing.value ? 'Save' : 'Edit',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.paddingL),
            // Avatar
            Obx(
              () {
                final photoUrl = controller.user.photoUrl;
                final hasPhoto = photoUrl != null &&
                    photoUrl.toString().isNotEmpty;
                final isLocalFile =
                    hasPhoto && !photoUrl.toString().startsWith('http');

                ImageProvider? imageProvider;
                if (hasPhoto) {
                  if (isLocalFile) {
                    imageProvider = FileImage(File(photoUrl));
                  } else {
                    imageProvider =
                        CachedNetworkImageProvider(photoUrl);
                  }
                }

                return Stack(
                  children: [
                    CircleAvatar(
                      radius: AppSizes.avatarSizeLarge / 2,
                      backgroundColor: AppColors.primary,
                      backgroundImage: imageProvider,
                      child: !hasPhoto
                          ? Text(
                              controller.user.initials,
                              style: GoogleFonts.inter(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    if (controller.isEditing.value)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickProfilePhoto,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  Color(0xFF5B8DEF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBackground
                                    : AppColors.background,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.camera,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSizes.paddingL),
            // Name — always Playfair Display
            Obx(
              () => controller.isEditing.value
                  ? TextFormField(
                      controller: controller.nameController,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: AppSizes.titleLarge,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    )
                  : Text(
                      controller.user.name,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: AppSizes.titleLarge,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              controller.user.email,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: AppSizes.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              '${AppStrings.joinedOn} ${Formatters.formatJoinedDate(controller.user.joinedDate)}',
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodySmall,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXXL),
            // Info cards
            _InfoCard(
              icon: LucideIcons.mail,
              label: 'Email',
              value: controller.user.email,
            ),
            const SizedBox(height: AppSizes.paddingM),
            _InfoCard(
              icon: LucideIcons.calendarDays,
              label: 'Member Since',
              value: Formatters.formatJoinedDate(controller.user.joinedDate),
            ),
            const SizedBox(height: AppSizes.paddingXXL),
            // Sign Out
            Obx(
              () => AnimatedPressButton(
                onPressed: controller.signOut,
                isLoading: controller.isSaving.value,
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                child: Text(
                  AppStrings.signOut,
                  style: GoogleFonts.inter(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSizes.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: AppSizes.labelSmall,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: AppSizes.bodyMedium,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
