import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../controller/home_controller.dart';

class AttachmentPopup extends GetView<HomeController> {
  const AttachmentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isAttachmentOpen.value) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;

      final items = [
        _AttachItemData(
          svgPath: 'assets/svg/icon_skin.svg',
          label: AppStrings.analyzeSkin,
          subtitle: 'Upload a photo for skin analysis',
          isComingSoon: false,
          onTap: () {
            controller.analyzeSkinLesion();
          },
        ),
        _AttachItemData(
          svgPath: 'assets/svg/icon_lung.svg',
          label: AppStrings.chestXray,
          subtitle: 'Analyze chest X-ray images',
          isComingSoon: false,
          onTap: () {
            controller.analyzeChestXRay();
          },
        ),
        _AttachItemData(
          svgPath: 'assets/svg/icon_document.svg',
          label: AppStrings.medicalReport,
          subtitle: 'Upload lab results or reports',
          isComingSoon: false,
          onTap: () {},
        ),
        _AttachItemData(
          svgPath: 'assets/svg/icon_chat.svg',
          label: AppStrings.viewHistory,
          subtitle: 'Browse past conversations',
          isComingSoon: false,
          onTap: () {
            controller.closeAttachmentMenu();
          },
        ),
      ];

      return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: AnimatedSlide(
          offset: controller.isAttachmentOpen.value
              ? Offset.zero
              : const Offset(0, 1),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 12),
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Text(
                      'Attach or Analyze',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.titleSmall,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // List items — no dividers between them, just like Claude
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _AttachListItem(item: item, isDark: isDark),
                        if (index !=
                            items.length - 1) // no divider after last item
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            indent: 74,
                            endIndent: 20,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.07),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _AttachItemData {
  final String svgPath;
  final String label;
  final String subtitle;
  final bool isComingSoon;
  final VoidCallback onTap;

  const _AttachItemData({
    required this.svgPath,
    required this.label,
    required this.subtitle,
    required this.isComingSoon,
    required this.onTap,
  });
}

// ─── List row widget ───────────────────────────────────────────────────────────

class _AttachListItem extends StatefulWidget {
  final _AttachItemData item;
  final bool isDark;

  const _AttachListItem({required this.item, required this.isDark});

  @override
  State<_AttachListItem> createState() => _AttachListItemState();
}

class _AttachListItemState extends State<_AttachListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final item = widget.item;

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            if (!item.isComingSoon) item.onTap();
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: _pressed
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04))
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Opacity(
              opacity: item.isComingSoon ? 0.5 : 1.0,
              child: Row(
                children: [
                  // Icon container — subtle background pill like Claude
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        item.svgPath,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Labels
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              item.label,
                              style: GoogleFonts.inter(
                                fontSize: AppSizes.bodySmall,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            if (item.isComingSoon) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Soon',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.darkTextPrimary.withValues(
                                    alpha: 0.5,
                                  )
                                : AppColors.textPrimary.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chevron — just like Claude's row arrows
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? Colors.white30 : Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
