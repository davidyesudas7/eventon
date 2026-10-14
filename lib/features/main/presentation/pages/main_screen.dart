import 'package:eventon/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:eventon/features/auth/presentation/providers/auth_providers.dart';
import 'package:eventon/features/chat/presentation/providers/chat_providers.dart';

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  // Colors matching the design. Swap selectedColor for AppColors.primary
  // if your primary is already this purple.
  static const Color _selectedColor = Color(0xFFA64D9A);
  static const Color _unselectedColor = Color(0xFF4A5A68);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isAuthenticated = authState is AuthStateAuthenticated;

    if (isAuthenticated) {
      ref.watch(chatSyncProvider);
    }

    final unreadCount = isAuthenticated
        ? ref.watch(totalUnreadMessagesCountProvider)
        : 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black26,
          indicatorColor: Colors.transparent, // no pill behind selected item
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              size: 26,
              color: selected ? _selectedColor : _unselectedColor,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? _selectedColor : _unselectedColor,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            if (index == 3 && isAuthenticated) {
              ref.invalidate(conversationsProvider);
            }
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.search),
              label: 'Explore',
            ),
            const NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
                child: const Icon(Icons.chat_bubble_outline),
              ),
              label: 'Chats',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
