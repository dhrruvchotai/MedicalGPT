import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../controller/home_controller.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_strings.dart';

class EmptyChatState extends GetView<HomeController> {
  const EmptyChatState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.paddingL),
            // SVG logo mark centered
            SvgPicture.asset('assets/svg/logo.svg', width: 64, height: 64),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              AppStrings.homeGreeting,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              AppStrings.homeSubtitle,
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodyMedium,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXL),
            // Suggestion chips with staggered animation
            _StaggeredSuggestions(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _StaggeredSuggestions extends StatefulWidget {
  final HomeController controller;
  const _StaggeredSuggestions({required this.controller});

  @override
  State<_StaggeredSuggestions> createState() => _StaggeredSuggestionsState();
}

class _StaggeredSuggestionsState extends State<_StaggeredSuggestions>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // (label, icon) — Lucide icons, no emojis
  final List<(String, IconData)> suggestions = [
    (AppStrings.suggestion1, LucideIcons.scanLine),
    (AppStrings.suggestion2, LucideIcons.messageCircle),
    (AppStrings.suggestion3, LucideIcons.fileText),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(suggestions.length, (i) {
        final delay = i * 0.15;
        final anim = CurvedAnimation(
          parent: _ctrl,
          curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
        );
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(anim),
            child: _SuggestionChipButton(
              label: suggestions[i].$1,
              icon: suggestions[i].$2,
              onTap: () =>
                  widget.controller.handleSuggestionTap(suggestions[i].$1),
            ),
          ),
        );
      }),
    );
  }
}

class _SuggestionChipButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SuggestionChipButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_SuggestionChipButton> createState() => _SuggestionChipButtonState();
}

class _SuggestionChipButtonState extends State<_SuggestionChipButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.primary,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.bodyMedium,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(LucideIcons.arrowRight,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
