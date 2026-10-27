import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppUI {
  // Spacing & Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0; // Used for main Node cards
  static const double radiusPill = 999.0; // Used for category chips

  // Reusable BorderRadius Objects
  static BorderRadius cardRadius = BorderRadius.circular(radiusLarge);
  static BorderRadius chipRadius = BorderRadius.circular(radiusPill);

  // Standardized Box Shadows
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: AppColors.textPrimary.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}