import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.primary,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.surface,
      dividerColor: AppColors.divider,
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme, AppColors.textPrimary),
      appBarTheme: _buildAppBarTheme(false),
      inputDecorationTheme: _buildInputDecorationTheme(false),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      cardTheme: _buildCardTheme(false),
      chipTheme: _buildChipTheme(false),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      switchTheme: _buildSwitchTheme(),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.primary,
        onSurface: AppColors.darkTextPrimary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,
      dividerColor: AppColors.darkDivider,
    );

    return base.copyWith(
      textTheme: _buildTextTheme(base.textTheme, AppColors.darkTextPrimary),
      appBarTheme: _buildAppBarTheme(true),
      inputDecorationTheme: _buildInputDecorationTheme(true),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      cardTheme: _buildCardTheme(true),
      chipTheme: _buildChipTheme(true),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
      ),
      switchTheme: _buildSwitchTheme(),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    final interTextTheme = GoogleFonts.interTextTheme(base);
    return interTextTheme.copyWith(
      displayLarge: interTextTheme.displayLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: interTextTheme.displayMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: interTextTheme.headlineLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: interTextTheme.headlineMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: interTextTheme.headlineSmall?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: interTextTheme.titleLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: interTextTheme.titleMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: interTextTheme.bodyLarge?.copyWith(color: textColor),
      bodyMedium: interTextTheme.bodyMedium?.copyWith(color: textColor),
      bodySmall: interTextTheme.bodySmall?.copyWith(
        color: textColor.withValues(alpha: 0.6),
      ),
      labelLarge: interTextTheme.labelLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme(bool isDark) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      foregroundColor:
          isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: AppSizes.titleLarge,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(bool isDark) {
    final borderColor = isDark ? AppColors.darkDivider : AppColors.border;

    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingM,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusInput),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: GoogleFonts.inter(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        fontSize: AppSizes.bodyMedium,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusButton),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: AppSizes.labelLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusButton),
        ),
        side: const BorderSide(color: AppColors.border),
        textStyle: GoogleFonts.inter(
          fontSize: AppSizes.labelLarge,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static CardThemeData _buildCardTheme(bool isDark) {
    return CardThemeData(
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.divider,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(0),
    );
  }

  static ChipThemeData _buildChipTheme(bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryLight,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.inter(
        fontSize: AppSizes.bodySmall,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusButton),
        side: BorderSide(
          color: isDark ? AppColors.darkDivider : AppColors.primary,
          width: 1,
        ),
      ),
    );
  }

  static SwitchThemeData _buildSwitchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.border;
      }),
    );
  }
}
