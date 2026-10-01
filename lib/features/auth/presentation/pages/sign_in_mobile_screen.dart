import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SignInMobileScreen extends StatelessWidget {
  const SignInMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 96),
                child: Row(
                  children: [
                    Text('Event', style: AppTextStyles.headlineLg.copyWith(color: AppColors.textPrimary)),
                    Text('On', style: AppTextStyles.headlineLg.copyWith(color: const Color(0xFF14B8A6))),
                  ],
                ),
              ),
              
              Text('Sign in', style: AppTextStyles.headlineXl.copyWith(fontSize: 28)),
              const SizedBox(height: 8),
              Text(
                'Welcome back to EventOn.',
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              
              Text('Mobile number', style: AppTextStyles.labelLg.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderStrong),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: Text('+91', style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary)),
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '98765 43210',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9DA3AF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: AppTextStyles.labelSm.copyWith(color: AppColors.textMuted)),
                    ),
                    Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
                  ],
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.blue),
                  label: const Text('Continue with Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: AppColors.borderSubtle),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Center(
                child: TextButton(
                  onPressed: () => context.go('/sign-in-email'),
                  child: Text('Use email and password instead', style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
                ),
              ),
              
              const Spacer(),
              
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New to EventOn? ', style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
                        GestureDetector(
                          onTap: () => context.go('/sign-up-email'),
                          child: Text(
                            'Create an account',
                            style: AppTextStyles.labelLg.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'List your business',
                        style: AppTextStyles.labelLg.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
