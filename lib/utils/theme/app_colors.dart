import 'package:flutter/material.dart';

class AppColors {
  // ============= LIGHT THEME =============

  // Primary Colors - Light
  static const Color lightPrimary = Color(0xFF192C4D); // Primary navy
  static const Color lightPrimaryVariant = Color(0xFF2C4B6B); // Midnight navy
  static const Color lightSecondary = Color(0xFF2DD4BF); // Electric green
  static const Color lightAccent = Color(0xFF5F8E7C); // Accent success

  // Background Colors - Light
  static const Color lightBackground = Color(0xFFF9FAFA); // Background light
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightCard = Color(0xFFFFFFFF); // Card white
  static const Color lightCardSecondary = Color(0xFFF7F8FA); // Subtle card

  // Text Colors - Light
  static const Color lightTextPrimary = Color(0xFF1A202C); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightTextTertiary = Color(0xFF708090); // Slate grey
  static const Color lightTextMuted = Color(0xFFA0AEC0); // Muted

  // Border Colors - Light
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle border
  static const Color lightDivider = Color(0xFFF7FAFC); // Ultra subtle divider

  // Financial Colors - Light
  static const Color lightProfit = Color(0xFF5F8E7C); // Accent success
  static const Color lightLoss = Color(0xFF8C5C5C); // Accent danger
  static const Color lightWarning = Color(0xFFE67E22); // Professional orange
  static const Color lightInfo = Color(0xFF2C4B6B); // Midnight navy

  // ============= DARK THEME  =============

  // Primary Colors - Dark
  static const Color darkPrimary = Color(0xFF192C4D); // Primary navy
  static const Color darkPrimaryVariant = Color(0xFF2C4B6B); // Midnight navy
  static const Color darkSecondary = Color(0xFF2DD4BF); // Electric green
  static const Color darkAccent = Color(0xFF5F8E7C); // Accent success

  // Background Colors - Dark
  static const Color darkBackground = Color(0xFF121416); // Background dark
  static const Color darkSurface = Color(0xFF1C1F24); // Slate card
  static const Color darkCard = Color(0xFF1C1F24); // Dark card
  static const Color darkCardSecondary = Color(0xFF2A2F36); // Elevated card

  // Text Colors - Dark
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextTertiary = Color(0xFF708090); // Slate grey
  static const Color darkTextMuted = Color(0xFF475569); // Slate 600

  // Border Colors - Dark
  static const Color darkBorder = Color(0xFF1E293B); // Slate 800
  static const Color darkDivider = Color(0xFF1C1F24); // Slate card

  // Financial Colors - Dark (Muted)
  static const Color darkProfit = Color(0xFF10B981); // Consistent green
  static const Color darkLoss = Color(0xFFEF4444); // Consistent red
  static const Color darkWarning = Color(0xFFF59E0B); // Amber
  static const Color darkInfo = Color(0xFF2C4B6B); // Midnight navy

  // ============= COMMON COLORS =============

  // Success States
  static const Color success = Color(0xFF5F8E7C);
  static const Color successLight = Color(0xFFE7F1EC);
  static const Color successDark = Color(0xFF2DD4BF);

  // Error States
  static const Color error = Color(0xFF8C5C5C);
  static const Color errorLight = Color(0xFFFED7D7);
  static const Color errorDark = Color(0xFF8C5C5C);

  // Warning States
  static const Color warning = Color(0xFFE67E22);
  static const Color warningLight = Color(0xFFFEF5E7);
  static const Color warningDark = Color(0xFFF59E0B);

  // Info States
  static const Color info = Color(0xFF2C4B6B);
  static const Color infoLight = Color(0xFFE6F3FF);
  static const Color infoDark = Color(0xFF2C4B6B);

  // Special Colors (Asset Categories)
  static const Color mutualFunds = Color(0xFF9C27B0); // Purple
  static const Color stocks = Color(0xFF00BCD4); // Cyan
  static const Color banks = Color(0xFF4CAF50); // Green
  static const Color nps = Color(0xFFFF9800); // Orange

  // Gradient Collections
  static const List<Color> profitGradient = [
    Color(0xFF5F8E7C),
    Color(0xFF2DD4BF),
  ];
  static const List<Color> lossGradient = [
    Color(0xFF8C5C5C),
    Color(0xFFE57373),
  ];
  static const List<Color> primaryGradient = [
    Color(0xFF192C4D),
    Color(0xFF2C4B6B),
  ];
  static const List<Color> darkGradient = [
    Color(0xFF121416),
    Color(0xFF1C1F24),
  ];

  // Chart Colors (Professional palette)
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF6B7280), // Gray
    Color(0xFFEC4899), // Pink
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // 10% black
  static const Color shadowDark = Color(0x33000000); // 20% black

  // Overlay Colors
  static const Color overlayLight = Color(0x0D000000); // 5% black
  static const Color overlayDark = Color(0x1A000000); // 10% black
}
