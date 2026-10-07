import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/auth_providers.dart';

class SignInMobileScreen extends ConsumerStatefulWidget {
  const SignInMobileScreen({super.key});

  @override
  ConsumerState<SignInMobileScreen> createState() => _SignInMobileScreenState();
}

class _SignInMobileScreenState extends ConsumerState<SignInMobileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePhoneContinue() async {
    final rawPhone = _phoneController.text
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (rawPhone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }

    final fullPhoneNumber = '+91$rawPhone';
    setState(() => _isLoading = true);

    try {
      final firebaseDs = ref.read(firebaseAuthDatasourceProvider);
      await firebaseDs.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        onVerificationCompleted: (credential) async {
          try {
            final userCredential = await FirebaseAuth.instance
                .signInWithCredential(credential);
            final idToken = await userCredential.user?.getIdToken();
            if (idToken != null) {
              final success = await ref
                  .read(authControllerProvider.notifier)
                  .firebaseSignIn(idToken: idToken);
              if (mounted && success) {
                context.go('/home');
              }
            }
          } catch (_) {}
        },
        onVerificationFailed: (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Phone verification failed')),
          );
        },
        onCodeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          context.push(
            '/otp-verify',
            extra: {
              'verificationId': verificationId,
              'phoneNumber': fullPhoneNumber,
            },
          );
        },
        onCodeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final firebaseDs = ref.read(firebaseAuthDatasourceProvider);
      final idToken = await firebaseDs.signInWithGoogle();

      final success = await ref
          .read(authControllerProvider.notifier)
          .firebaseSignIn(idToken: idToken);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        context.go('/home');
      } else {
        final authState = ref.read(authControllerProvider);
        if (authState is AuthStateError) {
          if (authState.failure is ProfileRequiredFailure) {
            context.go('/complete-profile', extra: idToken);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(authState.failure.message)));
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (!e.toString().contains('cancelled')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  void _handleClose() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleClose();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and optional close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Event',
                          style: AppTextStyles.headlineLg.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'On',
                          style: AppTextStyles.headlineLg.copyWith(
                            color: const Color(0xFF14B8A6),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: _handleClose,
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                Text(
                  'Sign in',
                  style: AppTextStyles.headlineXl.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back to EventOn.',
                  style: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'Mobile number',
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
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
                        child: Text(
                          '+91',
                          style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '98765 43210',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: AppTextStyles.bodyLg.copyWith(
                            color: AppColors.textPrimary,
                          ),
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
                    onPressed: _isLoading ? null : _handlePhoneContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF142328),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: AppColors.borderSubtle,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    icon: const Icon(
                      Icons.g_mobiledata,
                      size: 32,
                      color: Colors.blue,
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: AppColors.borderSubtle),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: TextButton(
                    onPressed: () => context.push('/sign-in-email'),
                    child: Text(
                      'Use email and password instead',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to EventOn? ',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/sign-up-email'),
                            child: Text(
                              'Create an account',
                              style: AppTextStyles.labelLg.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'List your business',
                          style: AppTextStyles.labelLg.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
