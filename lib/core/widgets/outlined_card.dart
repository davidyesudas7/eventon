import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 16,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: AppColors.borderSubtle);
    final borderRadius = BorderRadius.circular(radius);

    if (onTap != null) {
      return Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
  }
}
