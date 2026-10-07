import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/home_location_card.dart';
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    String name = 'Guest User';
    String contactInfo = 'Not signed in';

    if (authState is AuthStateAuthenticated) {
      name = authState.user.fullName;
      contactInfo =
          authState.user.email ?? authState.user.phone ?? 'No contact info';
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceBase,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Event',
              style: AppTextStyles.headlineLg.copyWith(
                color: const Color(0xFF13222a),
              ),
            ),
            Text(
              'On',
              style: AppTextStyles.headlineLg.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: AppTextStyles.headlineXl.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 24),

            // User Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderSubtle),
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.headlineSm),
                  const SizedBox(height: 4),
                  Text(
                    contactInfo,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Home Location Section
            const HomeLocationCard(),
            const SizedBox(height: 12),

            // Action Buttons
            InkWell(
              onTap: () => context.go('/bookings'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderSubtle),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Text('My bookings', style: AppTextStyles.labelLg),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/home');
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderSubtle),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Text(
                  'Log out',
                  style: AppTextStyles.labelLg.copyWith(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
