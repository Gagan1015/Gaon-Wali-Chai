import 'package:flutter/material.dart';

/// Application color palette
/// Based on the traditional chai theme with brown and beige tones
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors - Brown tones for chai theme
  static const Color primary = Color(0xFF8B4513); // Saddle brown
  static const Color primaryLight = Color(0xFFD2A679); // Light brown/beige
  static const Color primaryDark = Color(0xFF5C2E0A); // Dark brown

  // Secondary Colors - Warm earth tones
  static const Color secondary = Color(0xFFF5E6D3); // Cream/beige
  static const Color secondaryLight = Color(0xFFFFF8F0); // Very light cream
  static const Color accent = Color(0xFFFF8C42); // Orange accent

  // Background Colors
  static const Color background = Color(0xFFFFF8F0); // Light cream
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color cardBackground = Color(0xFFFFFFFF); // White

  // Text Colors
  static const Color textPrimary = Color(
    0xFF2D1810,
  ); // Dark brown, almost black
  static const Color textSecondary = Color(0xFF8B7355); // Medium brown
  static const Color textLight = Color(0xFFFFFFFF); // White
  static const Color textHint = Color(0xFFB8A391); // Light brown

  // UI Element Colors
  static const Color border = Color(0xFFE8D5C4); // Light brown border
  static const Color borderLight = Color(0xFFF5E6D3); // Very light border
  static const Color divider = Color(0xFFE8D5C4);

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFFA726); // Orange
  static const Color info = Color(0xFF2196F3); // Blue

  // Badge & Notification
  static const Color badgeBackground = Color(0xFFFF5252); // Bright red
  static const Color badgeText = Color(0xFFFFFFFF); // White

  // Shadow & Overlay
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color shimmer = Color(0xFFE8D5C4); // Light brown for skeleton

  // Category Colors (for category badges/chips)
  static const Color categoryHot = Color(0xFFFF6B6B);
  static const Color categoryCold = Color(0xFF4ECDC4);
  static const Color categorySnacks = Color(0xFFFFA07A);
  static const Color categoryDesserts = Color(0xFFDDA15E);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFF6B35)],
  );

  // Price Color
  static const Color price = Color(0xFF2D1810); // Dark brown
  static const Color priceDiscount = Color(
    0xFFFF5252,
  ); // Red for discounted price
  static const Color priceOriginal = Color(
    0xFF8B7355,
  ); // Strikethrough original price
}
