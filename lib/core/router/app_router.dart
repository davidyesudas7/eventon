import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/complete_profile_screen.dart';
import '../../features/auth/presentation/pages/otp_verify_screen.dart';
import '../../features/auth/presentation/pages/sign_in_email_screen.dart';
import '../../features/auth/presentation/pages/sign_in_mobile_screen.dart';
import '../../features/auth/presentation/pages/sign_up_email_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/bookings/domain/entities/booking.dart';
import '../../features/bookings/presentation/pages/booking_details_screen.dart';
import '../../features/bookings/presentation/pages/bookings_screen.dart';
import '../../features/chats/presentation/pages/chats_screen.dart';
import '../../features/explore/presentation/pages/explore_screen.dart';
import '../../features/explore/presentation/pages/explore_search_screen.dart';
import '../../features/explore/presentation/pages/explore_location_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/listings/presentation/pages/listing_details_screen.dart';
import '../../features/main/presentation/pages/main_screen.dart';

import '../../features/categories/presentation/pages/occasion_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/quotes/presentation/pages/request_quotes_screen.dart';
import '../../features/services/presentation/pages/all_services_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(
  debugLabel: 'explore',
);
final _shellNavigatorBookingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'bookings',
);
final _shellNavigatorChatsKey = GlobalKey<NavigatorState>(debugLabel: 'chats');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(
  debugLabel: 'profile',
);

@riverpod
GoRouter goRouter(Ref ref) {
  final authStateListener = ValueNotifier(ref.read(authControllerProvider));
  
  ref.listen(authControllerProvider, (previous, next) {
    authStateListener.value = next;
  });

  return GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: authStateListener,

    redirect: (context, state) {
      final isAuthenticated = authStateListener.value is AuthStateAuthenticated;
      final location = state.uri.toString();

      final protectedRoutes = ['/profile', '/bookings', '/chats', '/request-quotes'];

      final isProtectedRoute = protectedRoutes.any(
        (route) => location == route || location.startsWith('$route/'),
      );

      final isAuthRoute =
          location == '/sign-in-mobile' ||
          location == '/sign-in-email' ||
          location == '/sign-up-email' ||
          location == '/otp-verify' ||
          location == '/complete-profile';

      // Redirect guest users trying to access protected routes to full-screen mobile sign-in
      if (isProtectedRoute && !isAuthenticated) {
        return '/sign-in-mobile';
      }

      // Redirect authenticated users away from auth screens to home
      if (isAuthRoute && isAuthenticated) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in-mobile',
        builder: (context, state) => const SignInMobileScreen(),
      ),
      GoRoute(
        path: '/sign-in-email',
        builder: (context, state) => const SignInEmailScreen(),
      ),
      GoRoute(
        path: '/sign-up-email',
        builder: (context, state) => const SignUpEmailScreen(),
      ),
      GoRoute(
        path: '/otp-verify',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OtpVerifyScreen(
            verificationId: extra['verificationId'] as String? ?? '',
            phoneNumber: extra['phoneNumber'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (context, state) {
          final idToken = state.extra as String? ?? '';
          return CompleteProfileScreen(idToken: idToken);
        },
      ),
      GoRoute(
        path: '/request-quotes',
        builder: (context, state) => const RequestQuotesScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'all-services',
                    builder: (context, state) => const AllServicesScreen(),
                  ),
                  GoRoute(
                    path: 'occasion/:slug',
                    builder: (context, state) {
                      return OccasionScreen(
                        slug: state.pathParameters['slug']!,
                      );
                    },
                  ),
                  GoRoute(
                    path: 'listing/:id',
                    builder: (context, state) {
                      return ListingDetailsScreen(
                        listingId: state.pathParameters['id']!,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExploreKey,
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) {
                  final categoryId = state.extra as String?;
                  return ExploreScreen(initialCategoryId: categoryId);
                },
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => ExploreSearchScreen(
                      initialQuery: state.extra is String
                          ? state.extra as String
                          : '',
                    ),
                  ),
                  GoRoute(
                    path: 'location',
                    builder: (context, state) => const ExploreLocationScreen(),
                  ),
                  GoRoute(
                    path: 'listing/:id',
                    builder: (context, state) {
                      return ListingDetailsScreen(
                        listingId: state.pathParameters['id']!,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBookingsKey,
            routes: [
              GoRoute(
                path: '/bookings',
                builder: (context, state) => const BookingsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final booking = state.extra is Booking
                          ? state.extra as Booking
                          : findBookingById(state.pathParameters['id']!);
                      if (booking == null) {
                        return const Scaffold(
                          body: Center(child: Text('Booking not found')),
                        );
                      }
                      return BookingDetailsScreen(booking: booking);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorChatsKey,
            routes: [
              GoRoute(
                path: '/chats',
                builder: (context, state) => const ChatsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
