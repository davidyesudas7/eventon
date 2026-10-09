import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// An inline banner widget for displaying error messages directly above
/// the relevant input field or action button instead of floating snackbars.
class InlineErrorBanner extends StatelessWidget {
  final String? message;
  final VoidCallback? onDismiss;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const InlineErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    final text = message?.trim();
    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2), // Soft blush red
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFCA5A5), // Subtle red border
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFDC2626),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodySm.copyWith(
                  color: const Color(0xFF991B1B),
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
            ),
            if (onDismiss != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDismiss,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.close_rounded,
                    color: Color(0xFFDC2626),
                    size: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
