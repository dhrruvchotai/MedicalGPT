import 'package:flutter/material.dart' hide DrawerController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/drawer_controller.dart';
import '../../../data/services/auth_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/shimmer_list.dart';
import '../../../core/utils/formatters.dart';

class AppDrawer extends GetView<DrawerController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: AppSizes.drawerWidth,
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.darkSurface : AppColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDark ? AppColors.darkDivider : AppColors.divider,
                  ),
                ),
              ),
              child: Obx(
                () {
                  final photoUrl = authService.currentUser.value.photoUrl;
                  final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;
                  final isLocalFile = hasPhoto && !photoUrl.startsWith('http');

                  ImageProvider? imageProvider;
                  if (hasPhoto) {
                    if (isLocalFile) {
                      imageProvider = FileImage(File(photoUrl));
                    } else {
                      imageProvider = CachedNetworkImageProvider(photoUrl);
                    }
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        radius: AppSizes.avatarSizeMedium / 2,
                        backgroundColor: AppColors.primary,
                        backgroundImage: imageProvider,
                        child: !hasPhoto
                            ? Text(
                                authService.currentUser.value.initials,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              )
                            : null,
                      ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authService.currentUser.value.name,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.titleMedium,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            authService.currentUser.value.email,
                            style: GoogleFonts.inter(
                              fontSize: AppSizes.bodySmall,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            // New Chat button
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingM),
              child: InkWell(
                onTap: () => controller.startNewChat(),
                borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusButton),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.edit,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.newChat,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Recent Chats header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.recentChats,
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.labelSmall,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            // Chat history list
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? const ShimmerList(itemCount: 5)
                    : controller.chatHistory.isEmpty
                        ? Center(
                            child: Text(
                              'No chats yet',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: AppSizes.bodySmall,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: controller.chatHistory.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: isDark
                                  ? AppColors.darkDivider
                                  : AppColors.divider,
                            ),
                            itemBuilder: (context, i) {
                              final chat = controller.chatHistory[i];
                              final delay = i * 0.08;
                              return _FadeInItem(
                                delay: delay,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isDark
                                        ? AppColors.darkSurface
                                        : AppColors.primaryLight,
                                    child: Icon(
                                      LucideIcons.messageSquare,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  title: Text(
                                    chat.title,
                                    style: GoogleFonts.inter(
                                      fontSize: AppSizes.bodySmall,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    Formatters.formatChatTime(chat.updatedAt),
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  onTap: () => Get.back(),
                                  trailing: IconButton(
                                    icon: const Icon(LucideIcons.trash2,
                                        size: 16,
                                        color: AppColors.textSecondary),
                                    onPressed: () =>
                                        controller.deleteChat(chat.id),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
            Divider(
                height: 1,
                color:
                    isDark ? AppColors.darkDivider : AppColors.divider),
            // Bottom navigation links
            _DrawerBottomItem(
              icon: LucideIcons.user,
              label: AppStrings.profile,
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.profile);
              },
            ),
            _DrawerBottomItem(
              icon: LucideIcons.settings,
              label: AppStrings.settings,
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.settings);
              },
            ),
            _DrawerBottomItem(
              icon: LucideIcons.info,
              label: AppStrings.about,
              onTap: () {
                Get.back();
                Get.dialog(
                  AlertDialog(
                    title: const Text('About MedicalGPT'),
                    content: Text(
                      'MedicalGPT v1.0.0\nA family of medical AI models.\n\n${AppStrings.onboardingDisclaimer}',
                      style: GoogleFonts.inter(
                          fontSize: AppSizes.bodySmall),
                    ),
                    actions: [
                      TextButton(
                        onPressed: Get.back,
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.paddingS),
          ],
        ),
      ),
    );
  }
}

class _DrawerBottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerBottomItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(
        icon,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.textSecondary,
        size: 20,
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: AppSizes.bodyMedium,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}

class _FadeInItem extends StatefulWidget {
  final Widget child;
  final double delay;
  const _FadeInItem({required this.child, required this.delay});

  @override
  State<_FadeInItem> createState() => _FadeInItemState();
}

class _FadeInItemState extends State<_FadeInItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(
        Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fade, child: widget.child);
  }
}
