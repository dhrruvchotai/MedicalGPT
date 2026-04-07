import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/animated_press_button.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                const _Page1(),
                const _Page2(),
                _Page3(controller: controller),
              ],
            ),
            // Skip button
            Positioned(
              top: 16,
              right: 16,
              child: Obx(
                () => controller.isLastPage
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: controller.skip,
                        child: Text(
                          AppStrings.skip,
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
            // Bottom bar with dots + next button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                color: Colors.white,
                child: Obx(
                  () => controller.isLastPage
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Dot indicators
                            Obx(
                              () => Row(
                                children: List.generate(3, (i) {
                                  final isActive =
                                      controller.currentPage.value == i;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.only(right: 6),
                                    width: isActive ? 20 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppColors.primary
                                          : AppColors.border,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            // Next button
                            AnimatedPressButton(
                              onPressed: controller.nextPage,
                              width: 110,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                AppStrings.next,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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

// ─── Page 1 ───────────────────────────────────────────────────────────────────

class _Page1 extends StatefulWidget {
  const _Page1();

  @override
  State<_Page1> createState() => _Page1State();
}

class _Page1State extends State<_Page1> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 80, 32, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG logo mark as hero
            SvgPicture.asset('assets/svg/logo.svg', width: 120, height: 120),
            const SizedBox(height: AppSizes.paddingXL),
            Text(
              AppStrings.onboardingTitle1,
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              AppStrings.onboardingSubtitle1,
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodyLarge,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page 2 ───────────────────────────────────────────────────────────────────

class _Page2 extends StatefulWidget {
  const _Page2();

  @override
  State<_Page2> createState() => _Page2State();
}

class _Page2State extends State<_Page2> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  final List<_FeatureItem> features = const [
    _FeatureItem(
      null,
      AppStrings.featureSkinTitle,
      AppStrings.featureSkinDesc,
      false,
      iconData: LucideIcons.scanLine,
    ),
    _FeatureItem(
      'assets/svg/icon_lung.svg',
      AppStrings.featureChestTitle,
      AppStrings.featureChestDesc,
      false,
    ),
    _FeatureItem(
      'assets/svg/icon_chat.svg',
      AppStrings.featureChatTitle,
      AppStrings.featureChatDesc,
      false,
    ),
    _FeatureItem(
      'assets/svg/icon_document.svg',
      AppStrings.featureOcrTitle,
      AppStrings.featureOcrDesc,
      true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.onboardingTitle2,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            AppStrings.onboardingSubtitle2,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: AppSizes.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
          ...List.generate(features.length, (i) {
            final delay = i * 0.15;
            final anim = CurvedAnimation(
              parent: _ctrl,
              curve: Interval(delay, delay + 0.5, curve: Curves.easeOut),
            );
            return FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(anim),
                child: _FeatureCard(feature: features[i]),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final String? svgAsset;
  final IconData? iconData;
  final String title;
  final String desc;
  final bool isComingSoon;
  const _FeatureItem(this.svgAsset, this.title, this.desc, this.isComingSoon,
      {this.iconData});
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem feature;
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          if (feature.iconData != null)
            Icon(
              feature.iconData,
              size: 28,
              color: AppColors.primary,
            )
          else
            SvgPicture.asset(feature.svgAsset!, width: 28, height: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.bodyMedium,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  feature.desc,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.bodySmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (feature.isComingSoon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSizes.radiusButton),
              ),
              child: Text(
                AppStrings.comingSoon,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Page 3 — Disclaimer ──────────────────────────────────────────────────────

class _Page3 extends StatefulWidget {
  final OnboardingController controller;
  const _Page3({required this.controller});

  @override
  State<_Page3> createState() => _Page3State();
}

class _Page3State extends State<_Page3> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 80, 32, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shield icon using Lucide
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.shieldCheck,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              AppStrings.onboardingTitle3,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              AppStrings.onboardingDisclaimer,
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodyMedium,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              AppStrings.onboardingDisclaimerSub,
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodySmall,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXL),
            // CTA Button — full width, solid primary, no gradient
            AnimatedPressButton(
              onPressed: widget.controller.completeOnboarding,
              backgroundColor: AppColors.primary,
              child: Text(
                AppStrings.onboardingCta,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
