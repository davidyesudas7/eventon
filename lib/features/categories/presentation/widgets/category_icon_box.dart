import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'category_icon.dart';

class CategoryIconBox extends StatelessWidget {
  const CategoryIconBox({
    super.key,
    this.iconName,
    this.iconUrl,
    this.size = 72,
    this.iconSize = 32,
    this.radius = 22,
    this.color = AppColors.surfaceMintPill,
    this.iconColor = AppColors.primary,
  });

  final String? iconName;
  final String? iconUrl;
  final double size;
  final double iconSize;
  final double radius;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: CategoryIcon(
          iconName: iconName,
          iconUrl: iconUrl,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
