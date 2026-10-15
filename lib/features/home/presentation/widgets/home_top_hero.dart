import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/home_location_provider.dart';

class HomeTopHero extends ConsumerWidget {
  const HomeTopHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final locationState = ref.watch(homeLocationStateProvider);

    String greeting = 'Hi there,';
    String? initial;
    if (authState is AuthStateAuthenticated) {
      greeting = 'Hi ${authState.user.fullName},';
      if (authState.user.fullName.isNotEmpty) {
        initial = authState.user.fullName[0].toUpperCase();
      }
    }

    String locationTitle = 'Set your location';
    String locationSubtitle = 'See businesses near you';

    if (locationState.value != null) {
      final loc = locationState.value!;
      if (loc.lsgDetails != null && loc.lsgDetails!.name.isNotEmpty) {
        locationTitle = loc.lsgDetails!.name;
        locationSubtitle = loc.lsgDetails!.district;
      } else {
        locationTitle = loc.pincodeDetails.officeName;
        locationSubtitle = loc.pincodeDetails.district;
      }
    }

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Picker and Avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              locationTitle,
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textPrimary,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          locationSubtitle,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (initial != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      initial,
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Greeting
            Text(
              greeting,
              style: AppTextStyles.headlineLg.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                'what are we celebrating?',
                style: AppTextStyles.headlineLg.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
