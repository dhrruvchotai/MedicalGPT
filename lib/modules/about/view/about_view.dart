import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

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
          'About',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // ── Logo & App Identity ──────────────────────────
            _AnimatedLogo(isDark: isDark),
            const SizedBox(height: 20),
            Text(
              'MedicalGPT',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'A Family of Medical AI Models',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── What We Offer ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: 'What We Offer', isDark: isDark),
                  const SizedBox(height: 12),
                  _FeatureCard(
                    icon: LucideIcons.scan,
                    title: 'Skin Lesion Classifier',
                    description:
                        'AI-powered detection and classification of 8 types of skin lesions using deep learning models.',
                    gradient: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _FeatureCard(
                    icon: LucideIcons.heartPulse,
                    title: 'Chest X-Ray Analyzer',
                    description:
                        'Intelligent analysis of chest X-ray images to detect potential abnormalities and diseases.',
                    gradient: const [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _FeatureCard(
                    icon: LucideIcons.messageCircle,
                    title: 'Medical Chatbot',
                    description:
                        'Powered by BioMistral-7B — ask any health-related question and receive informative responses.',
                    gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _FeatureCard(
                    icon: LucideIcons.fileSearch,
                    title: 'Medical OCR',
                    description:
                        'Extract text from prescriptions, lab reports, and medical documents with precision.',
                    gradient: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Technology ───────────────────────────────────
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       _SectionTitle(title: 'Built With', isDark: isDark),
            //       const SizedBox(height: 12),
            //       _TechChipsRow(isDark: isDark),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 32),

            // ── Medical Disclaimer ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(
                    alpha: isDark ? 0.12 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusCard),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disclaimer',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'MedicalGPT is an AI-assisted tool for informational and research '
                            'purposes only. It is NOT a substitute for professional medical '
                            'advice, diagnosis, or treatment. Always consult a qualified '
                            'healthcare professional for all medical decisions.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Footer ──────────────────────────────────────
            Text(
              'Made with ❤️ for better healthcare',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '© 2026 MedicalGPT. All rights reserved.',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Animated Logo ────────────────────────────────────────────────────────────

class _AnimatedLogo extends StatefulWidget {
  final bool isDark;
  const _AnimatedLogo({required this.isDark});

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.15),
              AppColors.primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Center(
          child: SvgPicture.asset('assets/svg/logo.svg', width: 48, height: 48),
        ),
      ),
    );
  }
}

// ── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Feature Card ─────────────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;
  final bool isDark;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tech Chips Row ───────────────────────────────────────────────────────────

class _TechChipsRow extends StatelessWidget {
  final bool isDark;
  const _TechChipsRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final chips = [
      'Flutter',
      'BioMistral-7B',
      'TensorFlow',
      'Python',
      'HuggingFace',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.primary,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}