import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../controller/home_controller.dart';

class BottomInputBar extends GetView<HomeController> {
  const BottomInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.background,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkDivider : AppColors.divider,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Attachment toggle button
            Obx(
              () => AnimatedRotation(
                turns: controller.isAttachmentOpen.value ? 0.125 : 0.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: IconButton(
                  onPressed: controller.toggleAttachmentMenu,
                  icon: Icon(
                    controller.isAttachmentOpen.value
                        ? LucideIcons.x
                        : LucideIcons.plus,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Text input
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: controller.textController,
                  focusNode: controller.focusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.bodyMedium,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.inputHint,
                    hintStyle: GoogleFonts.inter(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      fontSize: AppSizes.bodyMedium,
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusBubble,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusBubble,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onChanged: controller.onTextChanged,
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button — always visible, disabled when empty
            Obx(() {
              final canTap =
                  controller.canSend.value && !controller.isLoading.value;
              return GestureDetector(
                onTap: canTap ? controller.sendMessage : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: AppSizes.sendButtonSize,
                  height: AppSizes.sendButtonSize,
                  decoration: BoxDecoration(
                    color: canTap
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.border),
                    borderRadius: BorderRadius.circular(AppSizes.radiusBubble),
                  ),
                  child: Center(
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            LucideIcons.arrowUp,
                            color: canTap
                                ? Colors.white
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                            size: 18,
                          ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
