import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/sign_in_email_screen.dart';
import '../../features/auth/presentation/pages/sign_in_mobile_screen.dart';
import '../../features/auth/presentation/pages/sign_up_email_screen.dart';
import '../../features/bookings/domain/entities/booking.dart';
import '../../features/bookings/presentation/pages/booking_details_screen.dart';
import '../../features/bookings/presentation/pages/bookings_screen.dart';
import '../../features/chats/presentation/pages/chats_screen.dart';
import '../../features/explore/presentation/pages/explore_screen.dart';
import '../../features/explore/presentation/pages/explore_search_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/listings/domain/entities/listing.dart';
import '../../features/listings/presentation/pages/listing_details_screen.dart';
import '../../features/main/presentation/pages/main_screen.dart';
import '../../features/occasions/domain/entities/occasion.dart';
import '../../features/occasions/presentation/pages/occasion_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
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
  return GoRouter(
    initialLocation: '/sign-in-email',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/sign-in-email',
        builder: (context, state) => const SignInEmailScreen(),
      ),
      GoRoute(
        path: '/sign-in-mobile',
        builder: (context, state) => const SignInMobileScreen(),
      ),
      GoRoute(
        path: '/sign-up-email',
        builder: (context, state) => const SignUpEmailScreen(),
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
                    path: 'occasion/:id',
                    builder: (context, state) {
                      final occasion = findOccasionById(state.pathParameters['id']!);
                      if (occasion == null) return const Scaffold(body: Center(child: Text('Not found')));
                      return OccasionScreen(occasion: occasion);
                    },
                  ),
                  GoRoute(
                    path: 'listing/:id',
                    builder: (context, state) {
                      final listing = findListingById(state.pathParameters['id']!);
                      if (listing == null) return const Scaffold(body: Center(child: Text('Not found')));
                      return ListingDetailsScreen(listing: listing);
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
                builder: (context, state) => const ExploreScreen(),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => ExploreSearchScreen(
                      initialQuery: state.extra is String ? state.extra as String : '',
                    ),
                  ),
                  GoRoute(
                    path: 'listing/:id',
                    builder: (context, state) {
                      final listing = findListingById(state.pathParameters['id']!);
                      if (listing == null) return const Scaffold(body: Center(child: Text('Not found')));
                      return ListingDetailsScreen(listing: listing);
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
                        return const Scaffold(body: Center(child: Text('Booking not found')));
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
