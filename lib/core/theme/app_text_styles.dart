import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static String? get fontFamily => GoogleFonts.dmSans().fontFamily;

  static TextStyle headlineXl = GoogleFonts.dmSans(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.02 * 36,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineLg = GoogleFonts.dmSans(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 32 / 26,
    letterSpacing: -0.015 * 26,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMd = GoogleFonts.dmSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 26 / 20,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineSm = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 22 / 16,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLg = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  static TextStyle bodyMd = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySm = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.textSecondary,
  );

  static TextStyle labelLg = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 22 / 15,
    color: AppColors.textPrimary,
  );

  static TextStyle labelMd = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    color: AppColors.textPrimary,
  );

  static TextStyle labelSm = GoogleFonts.dmSans(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 14 / 10,
    letterSpacing: 0.02 * 10,
    color: AppColors.textMuted,
  );
}
