import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.shieldCheck,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Privacy Matters',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Last updated: March 2026',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'We are committed to protecting your personal information and '
                    'your right to privacy. This policy describes how we collect, '
                    'use, and safeguard your data.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Sections
            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.database,
              iconColor: const Color(0xFF6366F1),
              title: '1. Information We Collect',
              items: const [
                _PolicyItem(
                  subtitle: 'Account Information',
                  body:
                      'When you create an account, we collect your name, email address, '
                      'and profile photo. If you sign in with Google, we receive your '
                      'basic Google profile information.',
                ),
                _PolicyItem(
                  subtitle: 'Chat Data',
                  body:
                      'Your chat messages and conversation history are stored locally '
                      'on your device using Hive database. We do not upload or store '
                      'your chat data on external servers.',
                ),
                _PolicyItem(
                  subtitle: 'Medical Images',
                  body:
                      'Images you upload for analysis (skin lesion photos, chest X-rays) '
                      'are sent to our AI backend for processing. These images are not '
                      'permanently stored and are deleted after analysis is complete.',
                ),
              ],
            ),

            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.settings,
              iconColor: const Color(0xFF06B6D4),
              title: '2. How We Use Your Information',
              items: const [
                _PolicyItem(
                  subtitle: 'Service Delivery',
                  body:
                      'We use your information solely to provide and improve the '
                      'MedicalGPT services, including AI-powered medical analysis '
                      'and chatbot functionality.',
                ),
                _PolicyItem(
                  subtitle: 'No Selling of Data',
                  body:
                      'We do NOT sell, rent, or share your personal information with '
                      'any third parties for marketing or advertising purposes.',
                ),
              ],
            ),

            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.lock,
              iconColor: const Color(0xFF10B981),
              title: '3. Data Security',
              items: const [
                _PolicyItem(
                  subtitle: 'Local Storage',
                  body:
                      'All chat history and user preferences are stored locally on '
                      'your device. This means your data stays with you and is not '
                      'accessible to us remotely.',
                ),
                _PolicyItem(
                  subtitle: 'Encrypted Transmission',
                  body:
                      'All communication between the app and our AI servers is '
                      'encrypted using industry-standard HTTPS/TLS protocols.',
                ),
              ],
            ),

            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.alertTriangle,
              iconColor: const Color(0xFFF59E0B),
              title: '4. Medical Disclaimer',
              items: const [
                _PolicyItem(
                  subtitle: 'Not Medical Advice',
                  body:
                      'MedicalGPT provides AI-assisted analysis for informational '
                      'and educational purposes only. Results should NOT be treated '
                      'as a medical diagnosis. Always consult a qualified healthcare '
                      'professional for medical decisions.',
                ),
                _PolicyItem(
                  subtitle: 'Accuracy Limitations',
                  body:
                      'While our AI models are trained on medical datasets, they '
                      'may produce inaccurate results. Users should independently '
                      'verify any information provided by the app.',
                ),
              ],
            ),

            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.userCheck,
              iconColor: const Color(0xFFEC4899),
              title: '5. Your Rights',
              items: const [
                _PolicyItem(
                  subtitle: 'Data Deletion',
                  body:
                      'You can delete your account and all associated data at any '
                      'time from Settings → Delete Account. Chat history can be '
                      'cleared individually from the navigation drawer.',
                ),
                _PolicyItem(
                  subtitle: 'Data Portability',
                  body:
                      'Since your data is stored locally, you have full control '
                      'over it. Uninstalling the app will remove all locally stored data.',
                ),
              ],
            ),

            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.baby,
              iconColor: const Color(0xFF8B5CF6),
              title: '6. Children\'s Privacy',
              items: const [
                _PolicyItem(
                  subtitle: 'Age Requirement',
                  body:
                      'MedicalGPT is not intended for use by individuals under the '
                      'age of 13. We do not knowingly collect personal information '
                      'from children under 13.',
                ),
              ],
            ),

            _PolicySection(
              isDark: isDark,
              icon: LucideIcons.refreshCw,
              iconColor: const Color(0xFF14B8A6),
              title: '7. Changes to This Policy',
              items: const [
                _PolicyItem(
                  subtitle: 'Updates',
                  body:
                      'We may update this Privacy Policy from time to time. Any '
                      'changes will be reflected in the app with a new "Last Updated" '
                      'date. Continued use of the app constitutes acceptance of the '
                      'revised policy.',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Contact info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                border: Border.all(
                  color: isDark ? AppColors.darkDivider : AppColors.divider,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    LucideIcons.mail,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Questions about this policy?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contact us at support@medicalgpt.app',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Policy Section ───────────────────────────────────────────────────────────

class _PolicySection extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<_PolicyItem> items;

  const _PolicySection({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 42, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      height: 1.6,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Policy Item Data ─────────────────────────────────────────────────────────

class _PolicyItem {
  final String subtitle;
  final String body;
  const _PolicyItem({required this.subtitle, required this.body});
}
