import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../chat/presentation/providers/chat_providers.dart';

class MainScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  static const Color _selectedColor = AppColors.primary;
  static const Color _unselectedColor = AppColors.textMuted;

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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bottomNavBg,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.bottomNavBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            indicatorColor: Colors.transparent, // no pill behind selected item
            height: 65,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            iconTheme: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return IconThemeData(
                size: 22,
                color: selected ? _selectedColor : _unselectedColor,
              );
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final selected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? _selectedColor : _unselectedColor,
              );
            }),
          ),
          child: NavigationBar(
            backgroundColor: AppColors.bottomNavBg,
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
                icon: FaIcon(FontAwesomeIcons.house),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                label: 'Explore',
              ),
              const NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.calendarDays),
                label: 'Bookings',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: unreadCount > 0,
                  label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
                  child: const FaIcon(FontAwesomeIcons.comment),
                ),
                label: 'Chats',
              ),
              const NavigationDestination(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
