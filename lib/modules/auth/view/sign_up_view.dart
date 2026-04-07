import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/animated_press_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controller/auth_controller.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.createAccount,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Form(
            key: controller.signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.createAccount,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  'Join MedicalGPT today',
                  style: GoogleFonts.inter(
                    color: textSecondary,
                    fontSize: AppSizes.bodyMedium,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXL),
                // Full Name
                AppTextField(
                  controller: controller.nameController,
                  hint: 'Your full name',
                  label: AppStrings.fullName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateFullName,
                  prefixIcon: const Icon(
                    LucideIcons.user,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                // Email
                AppTextField(
                  controller: controller.signUpEmailController,
                  hint: 'your@email.com',
                  label: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(
                    LucideIcons.mail,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                // Password + Strength
                Obx(
                  () => AppTextField(
                    controller: controller.signUpPasswordController,
                    hint: 'Min. 8 characters',
                    label: AppStrings.password,
                    obscureText: !controller.isSignUpPasswordVisible.value,
                    textInputAction: TextInputAction.next,
                    onChanged: controller.onPasswordChanged,
                    validator: Validators.validatePassword,
                    prefixIcon: const Icon(
                      LucideIcons.lock,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isSignUpPasswordVisible.value
                            ? LucideIcons.eye
                            : LucideIcons.eyeOff,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: controller.toggleSignUpPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                // Password Strength Indicator
                Obx(
                  () => controller.signUpPassword.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: controller.passwordStrength.value,
                                backgroundColor: AppColors.surface,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _strengthColor(
                                    controller.passwordStrength.value,
                                  ),
                                ),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _strengthLabel(controller.passwordStrength.value),
                              style: GoogleFonts.inter(
                                fontSize: AppSizes.labelSmall,
                                color: _strengthColor(
                                  controller.passwordStrength.value,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSizes.paddingM),
                // Confirm Password
                Obx(
                  () => AppTextField(
                    controller: controller.confirmPasswordController,
                    hint: 'Repeat your password',
                    label: AppStrings.confirmPassword,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    validator: (v) => Validators.validateConfirmPassword(
                      v,
                      controller.signUpPasswordController.text,
                    ),
                    prefixIcon: const Icon(
                      LucideIcons.lock,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value
                            ? LucideIcons.eye
                            : LucideIcons.eyeOff,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                // Terms checkbox
                Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: controller.agreedToTerms.value,
                        onChanged: (v) =>
                            controller.agreedToTerms.value = v ?? false,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            AppStrings.termsAgreement,
                            style: GoogleFonts.inter(
                              fontSize: AppSizes.bodySmall,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                // Error
                Obx(() {
                  if (controller.errorMessage.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
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
                            controller.errorMessage.value,
                            style: GoogleFonts.inter(
                              color: AppColors.error,
                              fontSize: AppSizes.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // Sign Up Button
                Obx(
                  () => AnimatedPressButton(
                    onPressed: controller.signUp,
                    isLoading: controller.isLoading.value,
                    child: Text(
                      AppStrings.createAccount,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
                // Divider
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
                // // Google Sign Up
                // Obx(
                //   () => AnimatedPressButton(
                //     onPressed: controller.signInWithGoogle,
                //     isLoading: controller.isLoading.value,
                //     backgroundColor: Colors.transparent,
                //     child: Container(
                //       width: double.infinity,
                //       height: 52,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: AppColors.border),
                //         borderRadius:
                //             BorderRadius.circular(AppSizes.radiusButton),
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(
                //         'assets/svg/google_logo.svg',
                //         width: 22,
                //         height: 22,
                //       ),
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
                // Sign In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.hasAccount,
                      style: GoogleFonts.inter(color: textSecondary),
                    ),
                    GestureDetector(
                      onTap: controller.goToSignIn,
                      child: Text(
                        AppStrings.signIn,
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
        ),
      ),
    );
  }

  Color _strengthColor(double strength) {
    if (strength < 0.3) return AppColors.error;
    if (strength < 0.6) return AppColors.warning;
    if (strength < 0.85) return AppColors.primary;
    return AppColors.success;
  }

  String _strengthLabel(double strength) {
    if (strength < 0.3) return 'Weak';
    if (strength < 0.6) return 'Fair';
    if (strength < 0.85) return 'Good';
    return 'Strong';
  }
}
