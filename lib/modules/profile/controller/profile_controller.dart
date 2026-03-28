import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/storage_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final RxBool isEditing = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = _authService.currentUser.value.name;
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  dynamic get user => _authService.currentUser.value;

  void toggleEdit() {
    if (isEditing.value) {
      // Cancel
      nameController.text = _authService.currentUser.value.name;
      isEditing.value = false;
    } else {
      isEditing.value = true;
    }
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    isSaving.value = true;
    try {
      await _authService.updateProfile(name: name);
      isEditing.value = false;
      Get.snackbar(
        'Profile Updated',
        'Your name has been updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  /// Show a bottom sheet to pick photo from camera or gallery
  void pickProfilePhoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Change Profile Photo',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Get.isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(
                'Take Photo',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Get.back();
                _pickAndSavePhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.photo_library_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(
                'Choose from Gallery',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Get.back();
                _pickAndSavePhoto(ImageSource.gallery);
              },
            ),
            if (_authService.currentUser.value.photoUrl != null &&
                _authService.currentUser.value.photoUrl!.isNotEmpty)
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.error, size: 20),
                ),
                title: Text(
                  'Remove Photo',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Get.back();
                  _removePhoto();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndSavePhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked == null) return;

      // Copy image to app's documents directory for persistence
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');

      await _authService.updateProfile(photoUrl: savedFile.path);

      Get.snackbar(
        'Photo Updated',
        'Your profile photo has been updated.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update profile photo. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _removePhoto() async {
    // We pass an empty string to photoUrl; but copyWith ignores null,
    // so we need a different approach — directly update the user model.
    final user = _authService.currentUser.value;
    _authService.currentUser.value = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      photoUrl: null,
      joinedDate: user.joinedDate,
    );
    await _authService.updateProfile(name: user.name);

    Get.snackbar(
      'Photo Removed',
      'Your profile photo has been removed.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.signIn);
  }

  void showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _storage.clearAll();
              Get.offAllNamed(AppRoutes.signIn);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
