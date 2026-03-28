import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/validators.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Sign In Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInFormKey = GlobalKey<FormState>();

  // Sign Up Controllers
  final nameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final signUpFormKey = GlobalKey<FormState>();

  // Reactive State
  final RxBool isLoading = false.obs;
  final RxBool isSignInPasswordVisible = false.obs;
  final RxBool isSignUpPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxDouble passwordStrength = 0.0.obs;
  final RxBool agreedToTerms = false.obs;
  final RxString signUpPassword = ''.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void onPasswordChanged(String password) {
    signUpPassword.value = password;
    passwordStrength.value = Validators.getPasswordStrength(password);
  }

  void toggleSignInPasswordVisibility() {
    isSignInPasswordVisible.value = !isSignInPasswordVisible.value;
  }

  void toggleSignUpPasswordVisibility() {
    isSignUpPasswordVisible.value = !isSignUpPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> signIn() async {
    if (!signInFormKey.currentState!.validate()) return;
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final result = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result.isSuccess) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value = result.error ?? 'Sign in failed.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;
    if (!agreedToTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please agree to the Terms of Service to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final result = await _authService.signUp(
        nameController.text.trim(),
        signUpEmailController.text.trim(),
        signUpPasswordController.text,
      );

      if (result.isSuccess) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value = result.error ?? 'Sign up failed.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final result = await _authService.signInWithGoogle();
      if (result.isSuccess) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        errorMessage.value = result.error ?? 'Google Sign-In failed.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() => Get.toNamed(AppRoutes.signUp);
  void goToSignIn() => Get.back();
}
