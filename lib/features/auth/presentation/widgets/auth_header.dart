import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
  });

  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineXl.copyWith(fontSize: 30),
        ),
        const SizedBox(height: 8),
        if (subtitleWidget != null)
          subtitleWidget!
        else if (subtitle != null)
          Text(
            subtitle!,
            style: AppTextStyles.bodyLg.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
