import 'dart:io';

void main() {
  final files = {
    'lib/core/error/failures.dart': '''
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
''',
    'lib/core/network/api_client.dart': '''
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.eventongo.in/v1")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
}
''',
    'lib/core/router/app_router.dart': '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/pages/sign_in_email_screen.dart';
import '../../features/auth/presentation/pages/sign_in_mobile_screen.dart';
import '../../features/auth/presentation/pages/sign_up_email_screen.dart';
import '../../features/bookings/presentation/pages/bookings_screen.dart';
import '../../features/chats/presentation/pages/chats_screen.dart';
import '../../features/explore/presentation/pages/explore_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/main/presentation/pages/main_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorExploreKey = GlobalKey<NavigatorState>(debugLabel: 'explore');
final _shellNavigatorBookingsKey = GlobalKey<NavigatorState>(debugLabel: 'bookings');
final _shellNavigatorChatsKey = GlobalKey<NavigatorState>(debugLabel: 'chats');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

@riverpod
GoRouter goRouter(GoRouterRef ref) {
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
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorExploreKey,
            routes: [
              GoRoute(
                path: '/explore',
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBookingsKey,
            routes: [
              GoRoute(
                path: '/bookings',
                builder: (context, state) => const BookingsScreen(),
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
''',
    'lib/features/main/presentation/pages/main_screen.dart': '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
''',
    'lib/features/auth/presentation/pages/sign_in_email_screen.dart': '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInEmailScreen extends StatelessWidget {
  const SignInEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In - Email')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/home'),
          child: const Text('Login'),
        ),
      ),
    );
  }
}
''',
    'lib/features/auth/presentation/pages/sign_in_mobile_screen.dart': '''
import 'package:flutter/material.dart';

class SignInMobileScreen extends StatelessWidget {
  const SignInMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In - Mobile')),
      body: const Center(child: Text('Sign In Mobile Screen')),
    );
  }
}
''',
    'lib/features/auth/presentation/pages/sign_up_email_screen.dart': '''
import 'package:flutter/material.dart';

class SignUpEmailScreen extends StatelessWidget {
  const SignUpEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up - Email')),
      body: const Center(child: Text('Sign Up Email Screen')),
    );
  }
}
''',
    'lib/features/home/presentation/pages/home_screen.dart': '''
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
''',
    'lib/features/explore/presentation/pages/explore_screen.dart': '''
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: const Center(child: Text('Explore Screen')),
    );
  }
}
''',
    'lib/features/bookings/presentation/pages/bookings_screen.dart': '''
import 'package:flutter/material.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: const Center(child: Text('Empty Bookings Screen')),
    );
  }
}
''',
    'lib/features/chats/presentation/pages/chats_screen.dart': '''
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: const Center(child: Text('Empty Chats Screen')),
    );
  }
}
''',
    'lib/features/profile/presentation/pages/profile_screen.dart': '''
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}
''',
  };

  for (final entry in files.entries) {
    final file = File(entry.key);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    print('Created: \${entry.key}');
  }
}
