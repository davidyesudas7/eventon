import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_routes.dart';
export 'app_routes.dart';

import '../../features/auth/presentation/pages/complete_profile_screen.dart';
import '../../features/auth/presentation/pages/otp_verify_screen.dart';
import '../../features/auth/presentation/pages/sign_in_email_screen.dart';
import '../../features/auth/presentation/pages/sign_in_mobile_screen.dart';
import '../../features/auth/presentation/pages/sign_up_email_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/bookings/presentation/pages/booking_details_screen.dart';
import '../../features/bookings/presentation/pages/bookings_screen.dart';
import '../../features/chat/presentation/pages/chats_screen.dart';
import '../../features/chat/presentation/pages/chat_detail_screen.dart';
import '../../features/explore/presentation/pages/explore_screen.dart';
import '../../features/explore/presentation/pages/explore_search_screen.dart';
import '../../features/explore/presentation/pages/explore_location_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/listings/presentation/pages/listing_details_screen.dart';
import '../../features/main/presentation/pages/main_screen.dart';

import '../../features/categories/presentation/pages/occasion_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/quotes/presentation/pages/request_quotes_screen.dart';
import '../../features/quotes/presentation/pages/quotes_listing_screen.dart';
import '../../features/quotes/presentation/pages/quotes_detail_screen.dart';
import '../../features/categories/presentation/pages/all_services_screen.dart';
import '../../features/vendors/presentation/pages/vendor_profile_screen.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
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
    initialLocation: AppRoutes.homePath,
    navigatorKey: rootNavigatorKey,
    refreshListenable: authStateListener,

    redirect: (context, state) {
      final isAuthenticated = authStateListener.value is AuthStateAuthenticated;
      final location = state.uri.toString();

      final protectedRoutes = [
        AppRoutes.profilePath,
        AppRoutes.bookingsPath,
        AppRoutes.chatsPath,
        AppRoutes.requestQuotesPath,
      ];

      final isProtectedRoute = protectedRoutes.any(
        (route) => location == route || location.startsWith('$route/'),
      );

      final isAuthRoute =
          location == AppRoutes.signInMobilePath ||
          location == AppRoutes.signInEmailPath ||
          location == AppRoutes.signUpEmailPath ||
          location == AppRoutes.otpVerifyPath ||
          location == AppRoutes.completeProfilePath;

      // Redirect guest users trying to access protected routes to full-screen mobile sign-in
      if (isProtectedRoute && !isAuthenticated) {
        return AppRoutes.signInMobilePath;
      }

      // Redirect authenticated users away from auth screens to home
      if (isAuthRoute && isAuthenticated) {
        return AppRoutes.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.signInMobile,
        path: AppRoutes.signInMobilePath,
        builder: (context, state) => const SignInMobileScreen(),
      ),
      GoRoute(
        name: AppRoutes.signInEmail,
        path: AppRoutes.signInEmailPath,
        builder: (context, state) => const SignInEmailScreen(),
      ),
      GoRoute(
        name: AppRoutes.signUpEmail,
        path: AppRoutes.signUpEmailPath,
        builder: (context, state) => const SignUpEmailScreen(),
      ),
      GoRoute(
        name: AppRoutes.otpVerify,
        path: AppRoutes.otpVerifyPath,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OtpVerifyScreen(
            verificationId: extra['verificationId'] as String? ?? '',
            phoneNumber: extra['phoneNumber'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        name: AppRoutes.completeProfile,
        path: AppRoutes.completeProfilePath,
        builder: (context, state) {
          final idToken = state.extra as String? ?? '';
          return CompleteProfileScreen(idToken: idToken);
        },
      ),
      GoRoute(
        name: AppRoutes.requestQuotes,
        path: AppRoutes.requestQuotesPath,
        builder: (context, state) => const RequestQuotesScreen(),
      ),
      GoRoute(
        name: AppRoutes.quoteRequests,
        path: AppRoutes.quoteRequestsPath,
        builder: (context, state) => const QuotesListingScreen(),
        routes: [
          GoRoute(
            name: AppRoutes.quoteRequestDetails,
            path: AppRoutes.quoteRequestDetailsSubPath,
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return QuotesDetailScreen(id: id);
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.vendorProfile,
        path: AppRoutes.vendorProfilePath,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VendorProfileScreen(vendorId: id);
        },
      ),
      GoRoute(
        path: '/vendor/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return VendorProfileScreen(vendorId: id);
        },
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
                name: AppRoutes.home,
                path: AppRoutes.homePath,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    name: AppRoutes.allServices,
                    path: AppRoutes.allServicesPath,
                    builder: (context, state) => const AllServicesScreen(),
                  ),
                  GoRoute(
                    name: AppRoutes.occasion,
                    path: AppRoutes.occasionPath,
                    builder: (context, state) {
                      return OccasionScreen(
                        slug: state.pathParameters['slug']!,
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.homeListingDetails,
                    path: AppRoutes.listingDetailsPath,
                    builder: (context, state) {
                      return ListingDetailsScreen(
                        listingId: state.pathParameters['id']!,
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.homeVendorProfile,
                    path: AppRoutes.vendorDetailsPath,
                    builder: (context, state) {
                      return VendorProfileScreen(
                        vendorId: state.pathParameters['id']!,
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
                name: AppRoutes.explore,
                path: AppRoutes.explorePath,
                builder: (context, state) {
                  final categoryId = state.extra as String?;
                  return ExploreScreen(initialCategoryId: categoryId);
                },
                routes: [
                  GoRoute(
                    name: AppRoutes.exploreSearch,
                    path: AppRoutes.exploreSearchPath,
                    builder: (context, state) => ExploreSearchScreen(
                      initialQuery: state.extra is String
                          ? state.extra as String
                          : '',
                    ),
                  ),
                  GoRoute(
                    name: AppRoutes.exploreLocation,
                    path: AppRoutes.exploreLocationPath,
                    builder: (context, state) => const ExploreLocationScreen(),
                  ),
                  GoRoute(
                    name: AppRoutes.exploreListingDetails,
                    path: AppRoutes.listingDetailsPath,
                    builder: (context, state) {
                      return ListingDetailsScreen(
                        listingId: state.pathParameters['id']!,
                      );
                    },
                  ),
                  GoRoute(
                    name: AppRoutes.exploreVendorProfile,
                    path: AppRoutes.vendorDetailsPath,
                    builder: (context, state) {
                      return VendorProfileScreen(
                        vendorId: state.pathParameters['id']!,
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
                name: AppRoutes.bookings,
                path: AppRoutes.bookingsPath,
                builder: (context, state) => const BookingsScreen(),
                routes: [
                  GoRoute(
                    name: AppRoutes.bookingDetails,
                    path: AppRoutes.bookingDetailsSubPath,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return BookingDetailsScreen(id: id);
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
                name: AppRoutes.chats,
                path: AppRoutes.chatsPath,
                builder: (context, state) => const ChatsScreen(),
                routes: [
                  GoRoute(
                    name: AppRoutes.chatDetails,
                    path: AppRoutes.chatDetailsSubPath,
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ChatDetailScreen(conversationId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                name: AppRoutes.profile,
                path: AppRoutes.profilePath,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
