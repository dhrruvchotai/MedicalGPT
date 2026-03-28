import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controller/settings_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
        title: Text(AppStrings.settings,
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        children: [
          // Appearance
          _SectionHeader(title: AppStrings.appearance),
          _SettingsCard(
            isDark: isDark,
            children: [
              Obx(
                () => _ToggleItem(
                  icon: LucideIcons.sun,
                  activeIcon: LucideIcons.moon,
                  isActive: controller.isDarkMode.value,
                  label: AppStrings.darkMode,
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          // Notifications
          // _SectionHeader(title: AppStrings.notifications),
          // _SettingsCard(
          //   isDark: isDark,
          //   children: [
          //     Obx(
          //       () => _ToggleItem(
          //         icon: LucideIcons.bell,
          //         label: AppStrings.enableNotifications,
          //         value: controller.notificationsEnabled.value,
          //         onChanged: controller.toggleNotifications,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: AppSizes.paddingM),
          // About
          _SectionHeader(title: AppStrings.aboutSection),
          _SettingsCard(
            isDark: isDark,
            children: [
              _LinkItem(
                icon: LucideIcons.info,
                label: '${AppStrings.appVersion}: ${controller.appVersion}',
                onTap: null,
                isDark: isDark,
              ),
              Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.divider),
              _LinkItem(
                icon: LucideIcons.shieldCheck,
                label: AppStrings.privacyPolicy,
                onTap: () {},
                isDark: isDark,
              ),
              Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.divider),
              _LinkItem(
                icon: LucideIcons.fileText,
                label: AppStrings.termsOfService,
                onTap: () {},
                isDark: isDark,
              ),
              Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.divider),
              _LinkItem(
                icon: LucideIcons.star,
                label: AppStrings.rateApp,
                onTap: () {},
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          // Account
          _SectionHeader(title: AppStrings.accountSection),
          _SettingsCard(
            isDark: isDark,
            children: [
              _LinkItem(
                icon: LucideIcons.trash2,
                label: AppStrings.deleteAccount,
                onTap: () {
                  if (Get.isRegistered<ProfileController>()) {
                    Get.find<ProfileController>()
                        .showDeleteAccountDialog();
                  } else {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Delete Account'),
                        content: const Text(
                          'Are you sure? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                              onPressed: Get.back,
                              child: const Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              Get.back();
                              Get.offAllNamed('/sign-in');
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.error),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                labelColor: AppColors.error,
                iconColor: AppColors.error,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXXL),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: AppSizes.labelSmall,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        child: Column(children: children),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final IconData? activeIcon;
  final bool isActive;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.icon,
    this.activeIcon,
    this.isActive = false,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isActive && activeIcon != null ? activeIcon! : icon,
          key: ValueKey(isActive),
          color: isActive
              ? AppColors.primary
              : isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
        ),
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: AppSizes.bodyMedium,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Color? iconColor;
  final bool isDark;

  const _LinkItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.labelColor,
    this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ??
            (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
        size: 20,
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: AppSizes.bodyMedium,
          color: labelColor ??
              (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
        ),
      ),
      trailing: onTap != null
          ? Icon(LucideIcons.chevronRight,
              color: AppColors.textSecondary, size: 18)
          : null,
      onTap: onTap,
    );
  }
}
