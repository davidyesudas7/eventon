import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'eventon_logo.dart';

/// White app bar with a back arrow (optional), a title or the "EventOn" wordmark,
/// and a subtle bottom divider.
class EventOnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EventOnAppBar({
    super.key,
    this.title,
    this.onBack,
    this.fallbackLocation = '/home',
    this.showBack = true,
    this.actions,
  });

  final String? title;
  final VoidCallback? onBack;
  final String fallbackLocation;
  final bool showBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: showBack ? 0 : 20,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed:
                  onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(fallbackLocation);
                    }
                  },
            )
          : null,
      title: title != null
          ? Text(
              title!,
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.textPrimary,
              ),
            )
          : const EventOnLogo(),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.borderSubtle, height: 1),
      ),
    );
  }
}
