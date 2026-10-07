import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/category.dart';
import 'category_icon_box.dart';

class CategoryGridTile extends StatelessWidget {
  const CategoryGridTile({super.key, required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.go('/explore', extra: category.id),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryIconBox(
            iconName: category.icon,
            iconUrl: category.iconUrl,
            size: 72,
            iconSize: 32,
            radius: 22,
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: 11.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
