import 'package:flutter/material.dart';

/// Legacy pastel color scheme preserved for reference or fallback.
class AppColorsLegacy {
  // Brand Colors
  static const Color primary = Color(0xFFAA5A9F);
  static const Color secondary = Color(0xFFAA5A9F);
  static const Color tertiary = Color(0xFFF59E0B);

  // Surfaces & Backgrounds
  static const Color surfaceBase = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF8FAFC);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color surfaceMintSubtle = Color(0xFFF4ECF3);
  static const Color surfaceMintPill = Color(0xFFDEDBEC);

  // Typography & Neutrals
  static const Color textPrimary = Color(0xFF16262B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // Status & Utility
  static const Color success = Color(0xFF14B8A6);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFCA5A5);
  static const Color errorIcon = Color(0xFFDC2626);
  static const Color errorText = Color(0xFF991B1B);
  static const Color warning = Color(0xFFFEF3C7);
  static const Color onWarning = Color(0xFF92400E);
  static const Color warningAccent = Color(0xFFD9822B);
  static const Color cancelBg = Color(0xFFC2410C);
  static const Color starRating = Color(0xFFFFB800);
  static const Color link = Color(0xFF3279A8);

  // Common UI & Essentials
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceWhite70 = Color(0xB3FFFFFF);
  static const Color surfaceWhite10 = Color(0x1AFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color socialGoogle = Color(0xFF000000);
  static const Color dividerDark = Color(0xFF1E293B);
  static const Color chipSelected = Color(0xFFE5EEED);

  // Feature specific tokens
  static const Color heroBanner = Color(0xFFDEDBEC);
  static const Color heroGradientBase = Color(0xFFDEDBEC);
  static const Color heroGradientPink = Color(0xFFF5B8E0);
  static const Color heroGradientBlue = Color(0xFF9FDEF5);
  static const Color heroGradientPeach = Color(0xFFFDE0B2);
  static const Color heroGradientLinearFade = Color(0x00DEDBEC);
  static const Color shadowSubtle = Color(0x0A000000);
  static const Color overlayDark = Color(0xB3000000);
  static const Color overlayMedium = Color(0x42000000);
  static const Color overlayStrong = Color(0xCC000000);
  static const Color promoBannerTag = Color(0xFFF5B876);
  static const Color cardPlaceholder = Color(0xFF424242);

  static const Color heroAccent = Color(0xFF78DDBE);
  static const Color heroAccentFg = Color(0xFF052922);
  static const Color promoCardBg = Color(0xFFFCF2DF);
  static const Color promoCardBorder = Color(0xFFFEF3C7);
  static const Color promoCardText = Color(0xFFB87616);
  static const Color featureCardBg = Color(0xFFF0F8F5);
  static const Color featureCardDark = Color(0xFF091F1C);
  static const Color trustBadgeBg = Color(0xFFE2F0FA);
  static const Color trustBadgeIcon = Color(0xFF268CEF);
  static const Color partnerCtaBg = Color(0xFF268CEF);

  // Occasion & Categories
  static const Color occasionBg = Color(0xFF131718);
  static const Color occasionCard = Color(0xFF23292B);
  static const Color occasionTitle = Color(0xFF1F2428);
  static const Color occasionSubtitle = Color(0xFF6A737D);
  static const Color occasionMeta = Color(0xFFADB5BD);

  // Chat & Quotes
  static const Color chatQuoteBorder = Color(0xFFE5E7EB);
  static const Color chatQuoteLabel = Color(0xFF6B7280);
  static const Color chatQuoteValue = Color(0xFF4B5563);
  static const Color chatQuoteTitle = Color(0xFF1F2937);

  static const Color ink = Color(0xFFAA5A9F);
  static const Color price = Color(0xFFAA5A9F);
  static const Color brandDeep = Color(0xFFAA5A9F);
  static const Color heroDark = Color(0xFFAA5A9F);
}

/// New Luxury Dark & Champagne Gold Theme
class AppColors {
  // Brand Colors (Warm Champagne Gold)
  static const Color primary = Color(0xFFDEAE5B); // Warm champagne gold
  static const Color primaryLight = Color(
    0xFFF3D084,
  ); // Shimmering gold highlight
  static const Color primaryDark = Color(0xFFC48E38); // Deep rich gold accent
  static const Color secondary = Color(0xFFE5B869); // Muted gold
  static const Color tertiary = Color(0xFFF59E0B); // Amber accent

  // Shimmering Gold Gradient
  static const List<Color> goldGradient = [
    Color(0xFFF5D695),
    Color(0xFFDEAE5B),
    Color(0xFFBA8732),
  ];

  // Surfaces & Backgrounds (Dark Charcoal & Obsidian)
  static const Color surfaceBase = Color(0xFF151618); // Level 0 app canvas
  static const Color surfaceElevated = Color(
    0xFF1D1F23,
  ); // Level 1 (Cards, Search bar)
  static const Color surfaceMuted = Color(
    0xFF222428,
  ); // Level 2 (Wells, Inner inputs)
  static const Color surfaceDark = Color(
    0xFF0C0D0E,
  ); // Level 3 (Deep pitch black curved section)
  static const Color surfaceMintSubtle = Color(0xFF24272D);
  static const Color surfaceMintPill = Color(
    0xFF22252B,
  ); // Category icon box card background
  static const Color bottomNavBg = Color(
    0xFF121315,
  ); // Bottom navigation bar background

  // Typography & Neutrals
  static const Color textPrimary = Color(
    0xFFFFFFFF,
  ); // High-contrast pure white
  static const Color textSecondary = Color(0xFF9096A2); // Muted slate-grey
  static const Color textMuted = Color(0xFF686E7B); // Deep muted grey
  static const Color borderSubtle = Color(
    0xFF2A2D34,
  ); // Subtle card/container outlines
  static const Color borderStrong = Color(
    0xFF3B404A,
  ); // Prominent input borders

  // Status & Utility
  static const Color success = Color(0xFF14B8A6);
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFF3B1212);
  static const Color onErrorContainer = Color(0xFFFCA5A5);
  static const Color errorBg = Color(0xFF261313);
  static const Color errorBorder = Color(0xFF5C2626);
  static const Color errorIcon = Color(0xFFEF4444);
  static const Color errorText = Color(0xFFFCA5A5);
  static const Color warning = Color(0xFF332205);
  static const Color onWarning = Color(0xFFFCD34D);
  static const Color warningAccent = Color(0xFFF59E0B);
  static const Color cancelBg = Color(0xFFC2410C);
  static const Color starRating = Color(0xFFFFB800);
  static const Color link = Color(0xFFDEAE5B);

  // Common UI & Essentials
  static const Color onPrimary = Color(0xFF151618); // Dark text on gold button
  static const Color surfaceWhite = Color(
    0xFF1D1F23,
  ); // Replaced with dark card color
  static const Color surfaceWhite70 = Color(0xB3FFFFFF);
  static const Color surfaceWhite10 = Color(0x1AFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color socialGoogle = Color(0xFFFFFFFF);
  static const Color dividerDark = Color(0xFF2A2D34);
  static const Color chipSelected = Color(
    0xFF2C2619,
  ); // Subtle gold tint dark chip

  // Feature specific tokens
  static const Color heroBanner = surfaceBase;
  static const Color heroGradientBase = Color(0xFF151618);
  static const Color heroGradientPink = Color(0xFF18181B); // Smooth dark tone
  static const Color heroGradientBlue = Color(0xFF15161A); // Smooth dark tone
  static const Color heroGradientPeach = Color(0xFF191715); // Smooth dark tone
  static const Color heroGradientLinearFade = Color(0x00151618);
  static const Color shadowSubtle = Color(0x40000000);
  static const Color overlayDark = Color(0xB3000000);
  static const Color overlayMedium = Color(0x66000000);
  static const Color overlayStrong = Color(0xE6000000);
  static const Color promoBannerTag = Color(0xFFDEAE5B);
  static const Color cardPlaceholder = Color(0xFF1D1F23);

  static const Color heroAccent = Color(0xFFDEAE5B);
  static const Color heroAccentFg = Color(0xFF151618);
  static const Color promoCardBg = Color(0xFF221E14);
  static const Color promoCardBorder = Color(0xFF3B321D);
  static const Color promoCardText = Color(0xFFE5B869);
  static const Color featureCardBg = Color(0xFF1D1F23);
  static const Color featureCardDark = Color(0xFF0C0D0E);
  static const Color trustBadgeBg = Color(0xFF1A1C20);
  static const Color trustBadgeIcon = Color(0xFFDEAE5B);
  static const Color partnerCtaBg = Color(0xFF1D1F23);

  // Occasion & Categories
  static const Color occasionBg = Color(0xFF151618);
  static const Color occasionCard = Color(0xFF1D1F23);
  static const Color occasionTitle = Color(0xFFFFFFFF);
  static const Color occasionSubtitle = Color(0xFF9096A2);
  static const Color occasionMeta = Color(0xFF686E7B);

  // Chat & Quotes
  static const Color chatQuoteBorder = Color(0xFF2A2D34);
  static const Color chatQuoteLabel = Color(0xFF9096A2);
  static const Color chatQuoteValue = Color(0xFFD1D5DB);
  static const Color chatQuoteTitle = Color(0xFFFFFFFF);

  // Custom added for deduplication
  static const Color ink = Color(0xFFFFFFFF);
  static const Color price = Color(0xFFDEAE5B);
  static const Color brandDeep = Color(0xFFDEAE5B);
  static const Color heroDark = Color(0xFF151618);
}
