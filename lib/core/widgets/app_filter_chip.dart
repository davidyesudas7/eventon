import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum FilterChipVariant { dark, mint }

class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.variant = FilterChipVariant.dark,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final FilterChipVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? (variant == FilterChipVariant.dark
            ? AppColors.ink
            : AppColors.surfaceMintPill)
        : Colors.white;

    final borderColor = isSelected
        ? (variant == FilterChipVariant.dark
            ? AppColors.ink
            : AppColors.primary)
        : AppColors.borderStrong; // or AppColors.borderSubtle

    final textColor = isSelected
        ? (variant == FilterChipVariant.dark
            ? Colors.white
            : const Color(0xFF164850))
        : AppColors.textPrimary; // or textSecondary

    return Material(
      color: bgColor,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: AppTextStyles.labelMd.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
