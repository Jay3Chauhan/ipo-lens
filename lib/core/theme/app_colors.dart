import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors - IPO Lens Palette
  static const Color lightPrimary = Color(0xFF192C4D); // Primary navy
  static const Color lightPrimaryVariant = Color(0xFF2C4B6B); // Midnight navy
  static const Color lightSecondary = Color(0xFF2DD4BF); // Electric green
  static const Color lightAccent = Color(0xFF5F8E7C); // Accent success

  // Advanced Gradient Colors
  static const List<Color> lightPrimaryGradient = [
    Color(0xFF192C4D),
    Color(0xFF2C4B6B),
  ];
  static const List<Color> lightSecondaryGradient = [
    Color(0xFF2DD4BF),
    Color(0xFF5F8E7C),
  ];
  static const List<Color> lightAccentGradient = [
    Color(0xFF5F8E7C),
    Color(0xFF2C4B6B),
  ];

  static const Color lightBackground = Color(0xFFF9FAFA); // Background light
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightSurfaceSecondary = Color(
    0xFFF7F8FA,
  ); // Card background
  static const Color lightSurfaceTertiary = Color(
    0xFFEEF1F5,
  ); // Disabled surface
  static const Color lightCard = Color(0xFFFFFFFF); // Card white

  static const Color lightText = Color(0xFF1A202C); // Professional dark
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightTextTertiary = Color(0xFF708090); // Slate grey
  static const Color lightTextMuted = Color(0xFFA0AEC0); // Very light gray

  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle border
  static const Color lightBorderSecondary = Color(0xFFCBD5E0); // Visible border
  static const Color lightDivider = Color(0xFFF7FAFC); // Ultra subtle divider

  // Enhanced Semantic Colors - Light Theme
  static const Color lightSuccess = Color(0xFF5F8E7C); // Accent success
  static const Color lightSuccessLight = Color(
    0xFFE7F1EC,
  ); // Success background
  static const Color lightError = Color(0xFF8C5C5C); // Accent danger
  static const Color lightErrorLight = Color(0xFFFED7D7); // Error background
  static const Color lightWarning = Color(0xFFE67E22); // Professional orange
  static const Color lightWarningLight = Color(
    0xFFFEF5E7,
  ); // Warning background
  static const Color lightInfo = Color(0xFF2C4B6B); // Midnight navy
  static const Color lightInfoLight = Color(0xFFE6F3FF); // Info background

  // Financial Colors - Light Theme (Professional)
  static const Color lightProfit = Color(0xFF5F8E7C); // Accent success
  static const Color lightLoss = Color(0xFF8C5C5C); // Accent danger
  static const Color lightNeutral = Color(0xFF708090); // Slate grey

  // Premium Colors
  static const Color lightGold = Color(0xFFD4AF37); // Gold accent
  static const Color lightPlatinum = Color(0xFFE5E5E5); // Platinum accent
  static const Color lightPremium = Color(0xFF8B5A2B); // Premium brown

  // Dark Theme Colors - Subtle Dark Palette
  static const Color darkPrimary = Color(0xFF192C4D); // Primary navy
  static const Color darkPrimaryVariant = Color(0xFF2C4B6B); // Midnight navy
  static const Color darkSecondary = Color(0xFF2DD4BF); // Electric green
  static const Color darkAccent = Color(0xFF5F8E7C); // Accent success

  static const Color darkBackground = Color(0xFF121416); // Background dark
  static const Color darkSurface = Color(0xFF1C1F24); // Slate card
  static const Color darkSurfaceSecondary = Color(0xFF1C1F24); // Slate card
  static const Color darkSurfaceTertiary = Color(
    0xFF2A2F36,
  ); // Elevated surface

  static const Color darkText = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextTertiary = Color(0xFF708090); // Slate grey

  static const Color darkBorder = Color(0xFF1E293B); // Slate 800
  static const Color darkBorderSecondary = Color(0xFF334155); // Slate 700
  static const Color darkDivider = Color(0xFF1C1F24); // Slate card

  // Semantic Colors - Dark Theme (Muted)
  static const Color darkSuccess = Color(0xFF5F8E7C); // Accent success
  static const Color darkSuccessLight = Color(0xFF24312D); // Muted success
  static const Color darkError = Color(0xFF8C5C5C); // Accent danger
  static const Color darkErrorLight = Color(0xFF3A2A2A); // Muted danger
  static const Color darkWarning = Color(0xFFF59E0B); // Amber
  static const Color darkWarningLight = Color(0xFF3A2B0A); // Muted amber
  static const Color darkInfo = Color(0xFF2C4B6B); // Midnight navy
  static const Color darkInfoLight = Color(0xFF1A2A3A); // Muted navy

  // Financial Colors - Dark Theme (Subtle)
  static const Color darkProfit = Color(0xFF10B981); // Consistent green
  static const Color darkLoss = Color(0xFFEF4444); // Consistent red
  static const Color darkNeutral = Color(0xFF9CA3AF); // Light gray

  // Subtle Gradient Collections
  static const List<Color> primaryGradient = [
    Color(0xFF192C4D),
    Color(0xFF2C4B6B),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF2DD4BF),
    Color(0xFF5F8E7C),
  ];

  static const List<Color> successGradient = [
    Color(0xFF5F8E7C),
    Color(0xFF2DD4BF),
  ];

  static const List<Color> errorGradient = [
    Color(0xFF8C5C5C),
    Color(0xFFE57373),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFD97706),
    Color(0xFFF59E0B),
  ];

  static const List<Color> profitGradient = [
    Color(0xFF5F8E7C),
    Color(0xFF2DD4BF),
  ];

  static const List<Color> premiumGradient = [
    Color(0xFF192C4D),
    Color(0xFF2C4B6B),
  ];

  // Subtle Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Primary indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF6B7280), // Gray
    Color(0xFFEC4899), // Pink
    Color(0xFF84CC16), // Lime
    Color(0xFFF97316), // Orange
  ];
}

extension ThemeExtension on ThemeData {
  AppColorsTheme get appColors => brightness == Brightness.light
      ? AppColorsTheme.light()
      : AppColorsTheme.dark();
}

class AppColorsTheme {
  // Core Colors
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color accent;
  final List<Color> lightPrimaryGradient;

  // Surface Colors
  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color surfaceTertiary;

  // Text Colors
  final Color text;
  final Color textSecondary;
  final Color textTertiary;

  // Border & Divider Colors
  final Color border;
  final Color borderSecondary;
  final Color divider;

  // Semantic Colors
  final Color success;
  final Color successLight;
  final Color error;
  final Color errorLight;
  final Color warning;
  final Color warningLight;
  final Color info;
  final Color infoLight;

  // Financial Colors
  final Color profit;
  final Color loss;
  final Color neutral;

  // Gradients
  final List<Color> primaryGradient;
  final List<Color> secondaryGradient;
  final List<Color> successGradient;
  final List<Color> errorGradient;
  final List<Color> warningGradient;
  final List<Color> profitGradient;
  final List<Color> premiumGradient;

  // Chart Colors
  final List<Color> chartColors;

  AppColorsTheme({
    required this.primary,
    required this.lightPrimaryGradient,
    required this.primaryVariant,

    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.surfaceTertiary,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.borderSecondary,
    required this.divider,
    required this.success,
    required this.successLight,
    required this.error,
    required this.errorLight,
    required this.warning,
    required this.warningLight,
    required this.info,
    required this.infoLight,
    required this.profit,
    required this.loss,
    required this.neutral,
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.successGradient,
    required this.errorGradient,
    required this.warningGradient,
    required this.profitGradient,
    required this.premiumGradient,
    required this.chartColors,
  });

  factory AppColorsTheme.light() => AppColorsTheme(
    lightPrimaryGradient: AppColors.lightPrimaryGradient,

    // Core Colors
    primary: AppColors.lightPrimary,
    primaryVariant: AppColors.lightPrimaryVariant,
    secondary: AppColors.lightSecondary,
    accent: AppColors.lightAccent,

    // Surface ColorsCo
    background: AppColors.lightBackground,
    surface: const Color.fromARGB(255, 240, 240, 240),
    surfaceSecondary: AppColors.lightSurfaceSecondary,
    surfaceTertiary: AppColors.lightSurfaceTertiary,

    // Text Colors
    text: AppColors.lightText,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,

    // Border & Divider Colors
    border: AppColors.lightBorder,
    borderSecondary: AppColors.lightBorderSecondary,
    divider: AppColors.lightDivider,

    // Semantic Colors
    success: AppColors.lightSuccess,
    successLight: AppColors.lightSuccessLight,
    error: AppColors.lightError,
    errorLight: AppColors.lightErrorLight,
    warning: AppColors.lightWarning,
    warningLight: AppColors.lightWarningLight,
    info: AppColors.lightInfo,
    infoLight: AppColors.lightInfoLight,

    // Financial Colors
    profit: AppColors.lightProfit,
    loss: AppColors.lightLoss,
    neutral: AppColors.lightNeutral,

    // Gradients
    primaryGradient: AppColors.primaryGradient,
    secondaryGradient: AppColors.secondaryGradient,
    successGradient: AppColors.successGradient,
    errorGradient: AppColors.errorGradient,
    warningGradient: AppColors.warningGradient,
    profitGradient: AppColors.profitGradient,
    premiumGradient: AppColors.premiumGradient,

    // Chart Colors
    chartColors: AppColors.chartColors,
  );

  factory AppColorsTheme.dark() => AppColorsTheme(
    lightPrimaryGradient: AppColors.lightPrimaryGradient,
    // Core Colors
    primary: AppColors.darkPrimary,
    primaryVariant: AppColors.darkPrimaryVariant,
    secondary: AppColors.darkSecondary,
    accent: AppColors.darkAccent,

    // Surface Colors
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceSecondary: AppColors.darkSurfaceSecondary,
    surfaceTertiary: AppColors.darkSurfaceTertiary,

    // Text Colors
    text: AppColors.darkText,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,

    // Border & Divider Colors
    border: AppColors.darkBorder,
    borderSecondary: AppColors.darkBorderSecondary,
    divider: AppColors.darkDivider,

    // Semantic Colors
    success: AppColors.darkSuccess,
    successLight: AppColors.darkSuccessLight,
    error: AppColors.darkError,
    errorLight: AppColors.darkErrorLight,
    warning: AppColors.darkWarning,
    warningLight: AppColors.darkWarningLight,
    info: AppColors.darkInfo,
    infoLight: AppColors.darkInfoLight,

    // Financial Colors
    profit: AppColors.darkProfit,
    loss: AppColors.darkLoss,
    neutral: AppColors.darkNeutral,

    // Gradients
    primaryGradient: AppColors.primaryGradient,
    secondaryGradient: AppColors.secondaryGradient,
    successGradient: AppColors.successGradient,
    errorGradient: AppColors.errorGradient,
    warningGradient: AppColors.warningGradient,
    profitGradient: AppColors.profitGradient,
    premiumGradient: AppColors.premiumGradient,

    // Chart Colors
    chartColors: AppColors.chartColors,
  );

  // Helper method to get subtle overlay colors
  Color getSubtleOverlay(Color baseColor, {double opacity = 0.05}) {
    return baseColor.withValues(alpha: opacity);
  }

  // Helper method for very subtle hover states
  Color getSubtleHover(Color baseColor, {double opacity = 0.04}) {
    return baseColor.withValues(alpha: opacity);
  }

  // Helper method for subtle pressed states
  Color getSubtlePressed(Color baseColor, {double opacity = 0.08}) {
    return baseColor.withValues(alpha: opacity);
  }

  // Helper method for subtle borders
  Color getSubtleBorder({double opacity = 0.1}) {
    return text.withValues(alpha: opacity);
  }

  // Method to get appropriate text color with lower contrast
  Color getSoftTextColor(Color backgroundColor) {
    double luminance = backgroundColor.computeLuminance();
    if (luminance > 0.5) {
      // Light background - use softer dark text
      return const Color(0xFF4B5563);
    } else {
      // Dark background - use softer light text
      return const Color(0xFFE5E7EB);
    }
  }
}

// Extension for easy color usage in widgets
extension ColorHelpers on BuildContext {
  AppColorsTheme get colors => Theme.of(this).appColors;
}
