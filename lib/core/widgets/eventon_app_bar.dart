import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// White app bar with a back arrow, the "EventOn" wordmark and a subtle
/// bottom divider.
class EventOnAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EventOnAppBar({super.key, this.onBack, this.fallbackLocation = '/home'});

  /// Custom back behaviour. Defaults to popping, or going to
  /// [fallbackLocation] when there is nothing to pop.
  final VoidCallback? onBack;
  final String fallbackLocation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: onBack ??
            () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(fallbackLocation);
              }
            },
      ),
      title: Row(
        children: [
          Text('Event', style: AppTextStyles.headlineMd.copyWith(color: AppColors.textPrimary)),
          Text('On', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.borderSubtle, height: 1),
      ),
    );
  }
}
