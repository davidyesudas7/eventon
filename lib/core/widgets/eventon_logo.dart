import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EventOnLogo extends StatelessWidget {
  const EventOnLogo({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? AppTextStyles.headlineMd;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Event',
          style: baseStyle.copyWith(color: AppColors.textPrimary),
        ),
        Text(
          'On',
          style: baseStyle.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
