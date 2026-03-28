import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _borderController;
  late Animation<double> _borderAnimation;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _borderAnimation = CurvedAnimation(
      parent: _borderController,
      curve: Curves.easeInOut,
    );
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _borderController.forward();
    } else {
      _borderController.reverse();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.inter(
              fontSize: AppSizes.labelLarge,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXS),
        ],
        AnimatedBuilder(
          animation: _borderAnimation,
          builder: (context, child) {
            return TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              textInputAction: widget.textInputAction,
              onFieldSubmitted: widget.onSubmitted,
              style: GoogleFonts.inter(
                fontSize: AppSizes.bodyMedium,
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon,
                hintStyle: GoogleFonts.inter(
                  color:
                      isDark ? AppColors.darkTextSecondary : AppColors.textHint,
                  fontSize: AppSizes.bodyMedium,
                ),
                filled: true,
                fillColor:
                    isDark ? AppColors.darkSurfaceVariant : AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingM,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkDivider : AppColors.border,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.darkDivider : AppColors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  borderSide: const BorderSide(
                    color: AppColors.focusedBorder,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
