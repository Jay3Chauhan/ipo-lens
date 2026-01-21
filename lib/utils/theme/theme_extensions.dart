import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Extension to access AppColors from Theme
extension ThemeAppColors on ThemeData {
  AppColorsExtension get appColors {
    return brightness == Brightness.dark
        ? AppColorsExtension.dark()
        : AppColorsExtension.light();
  }
}

/// Color extension for easy access
class AppColorsExtension {
  // Primary Colors
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color accent;

  // Background Colors
  final Color background;
  final Color surface;
  final Color card;
  final Color cardSecondary;

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textMuted;

  // Border Colors
  final Color border;
  final Color divider;

  // Financial Colors
  final Color profit;
  final Color loss;
  final Color warning;
  final Color info;

  // Asset Colors
  final Color mutualFunds;
  final Color stocks;
  final Color banks;
  final Color nps;

  // Gradients
  final List<Color> primaryGradient;
  final List<Color> profitGradient;
  final List<Color> lossGradient;
  final List<Color> darkGradient;

  // Shadow & Overlay
  final Color shadow;
  final Color overlay;

  const AppColorsExtension({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.card,
    required this.cardSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.profit,
    required this.loss,
    required this.warning,
    required this.info,
    required this.mutualFunds,
    required this.stocks,
    required this.banks,
    required this.nps,
    required this.primaryGradient,
    required this.profitGradient,
    required this.lossGradient,
    required this.darkGradient,
    required this.shadow,
    required this.overlay,
  });

  factory AppColorsExtension.light() {
    return const AppColorsExtension(
      primary: AppColors.lightPrimary,
      primaryVariant: AppColors.lightPrimaryVariant,
      secondary: AppColors.lightSecondary,
      accent: AppColors.lightAccent,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      card: AppColors.lightCard,
      cardSecondary: AppColors.lightCardSecondary,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      textTertiary: AppColors.lightTextTertiary,
      textMuted: AppColors.lightTextMuted,
      border: AppColors.lightBorder,
      divider: AppColors.lightDivider,
      profit: AppColors.lightProfit,
      loss: AppColors.lightLoss,
      warning: AppColors.lightWarning,
      info: AppColors.lightInfo,
      mutualFunds: AppColors.mutualFunds,
      stocks: AppColors.stocks,
      banks: AppColors.banks,
      nps: AppColors.nps,
      primaryGradient: AppColors.primaryGradient,
      profitGradient: AppColors.profitGradient,
      lossGradient: AppColors.lossGradient,
      darkGradient: AppColors.darkGradient,
      shadow: AppColors.shadowLight,
      overlay: AppColors.overlayLight,
    );
  }

  factory AppColorsExtension.dark() {
    return const AppColorsExtension(
      primary: AppColors.darkPrimary,
      primaryVariant: AppColors.darkPrimaryVariant,
      secondary: AppColors.darkSecondary,
      accent: AppColors.darkAccent,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      card: AppColors.darkCard,
      cardSecondary: AppColors.darkCardSecondary,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      textTertiary: AppColors.darkTextTertiary,
      textMuted: AppColors.darkTextMuted,
      border: AppColors.darkBorder,
      divider: AppColors.darkDivider,
      profit: AppColors.darkProfit,
      loss: AppColors.darkLoss,
      warning: AppColors.darkWarning,
      info: AppColors.darkInfo,
      mutualFunds: AppColors.mutualFunds,
      stocks: AppColors.stocks,
      banks: AppColors.banks,
      nps: AppColors.nps,
      primaryGradient: AppColors.primaryGradient,
      profitGradient: AppColors.profitGradient,
      lossGradient: AppColors.lossGradient,
      darkGradient: AppColors.darkGradient,
      shadow: AppColors.shadowDark,
      overlay: AppColors.overlayDark,
    );
  }
}
