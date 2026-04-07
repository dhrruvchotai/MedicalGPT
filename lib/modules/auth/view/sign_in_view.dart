import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/animated_press_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controller/auth_controller.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Form(
            key: controller.signInFormKey,
            child: _AnimatedSignInContent(controller: controller),
          ),
        ),
      ),
    );
  }
}

class _AnimatedSignInContent extends StatefulWidget {
  final AuthController controller;
  const _AnimatedSignInContent({required this.controller});

  @override
  State<_AnimatedSignInContent> createState() => _AnimatedSignInContentState();
}

class _AnimatedSignInContentState extends State<_AnimatedSignInContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textPrimary = colorScheme.onSurface;
    final textSecondary = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSizes.paddingXXL),
            // SVG Logo mark
            SvgPicture.asset('assets/svg/logo.svg', width: 56, height: 56),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'MedicalGPT',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              AppStrings.welcomeBack,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              AppStrings.signInSubtitle,
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodyMedium,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
            // Email
            AppTextField(
              controller: widget.controller.emailController,
              hint: 'Enter your email',
              label: AppStrings.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return AppStrings.emailRequired;
                }
                return null;
              },
              prefixIcon: const Icon(
                LucideIcons.mail,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            // Password
            Obx(
              () => AppTextField(
                controller: widget.controller.passwordController,
                hint: 'Enter your password',
                label: AppStrings.password,
                obscureText: !widget.controller.isSignInPasswordVisible.value,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return AppStrings.passwordRequired;
                  }
                  return null;
                },
                prefixIcon: const Icon(
                  LucideIcons.lock,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    widget.controller.isSignInPasswordVisible.value
                        ? LucideIcons.eye
                        : LucideIcons.eyeOff,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: widget.controller.toggleSignInPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  AppStrings.forgotPassword,
                  style: GoogleFonts.inter(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: AppSizes.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingS),
            // Error message
            Obx(
              () => widget.controller.errorMessage.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            LucideIcons.alertCircle,
                            color: AppColors.error,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.controller.errorMessage.value,
                              style: GoogleFonts.inter(
                                color: AppColors.error,
                                fontSize: AppSizes.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // Sign In Button
            Obx(
              () => AnimatedPressButton(
                onPressed: widget.controller.signIn,
                isLoading: widget.controller.isLoading.value,
                child: Text(
                  AppStrings.signIn,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.labelLarge,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            // Divider with "or"
            // Row(
            //   children: [
            //     Expanded(child: Divider(color: Theme.of(context).dividerColor)),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 12),
            //       child: Text(
            //         AppStrings.or,
            //         style: GoogleFonts.inter(
            //           color: textSecondary,
            //           fontSize: AppSizes.bodySmall,
            //         ),
            //       ),
            //     ),
            //     Expanded(child: Divider(color: Theme.of(context).dividerColor)),
            //   ],
            // ),
            // const SizedBox(height: AppSizes.paddingL),
            // Google Sign In
            // Obx(
            //   () => AnimatedPressButton(
            //     onPressed: widget.controller.signInWithGoogle,
            //     isLoading: widget.controller.isLoading.value,
            //     backgroundColor: Colors.transparent,
            //     child: Container(
            //       width: double.infinity,
            //       height: 52,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: AppColors.border),
            //         borderRadius: BorderRadius.circular(AppSizes.radiusButton),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           // Google "G" text as logo stand-in
            //           SvgPicture.asset(
            //             'assets/svg/google_logo.svg',
            //             width: 22,
            //             height: 22,
            //           ),
            //           const SizedBox(width: 10),
            //           Text(
            //             AppStrings.continueWithGoogle,
            //             style: GoogleFonts.inter(
            //               fontWeight: FontWeight.w500,
            //               color: textPrimary,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: AppSizes.paddingL),
            // Sign Up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.noAccount,
                  style: GoogleFonts.inter(color: textSecondary),
                ),
                GestureDetector(
                  onTap: widget.controller.goToSignUp,
                  child: Text(
                    AppStrings.signUp,
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingL),
          ],
        ),
      ),
    );
  }
}
