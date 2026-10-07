import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/typewriter_hint.dart';
import '../../../categories/presentation/providers/categories_providers.dart';

class HomeSearchBar extends ConsumerStatefulWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  Timer? _hintTimer;
  int _currentHintIndex = 0;
  List<String> _hintCategories = ['services']; // fallback

  @override
  void initState() {
    super.initState();
    _startHintTimer();
  }

  void _startHintTimer() {
    _hintTimer?.cancel();
    _hintTimer = Timer.periodic(const Duration(seconds: 2, milliseconds: 500), (
      timer,
    ) {
      if (_hintCategories.length <= 1) return;
      if (mounted) {
        setState(() {
          _currentHintIndex = (_currentHintIndex + 1) % _hintCategories.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to categories to update hints
    ref.listen(categoriesProvider, (previous, next) {
      next.whenData((categories) {
        if (categories.isNotEmpty) {
          final newHints = categories.map((c) => c.name.toLowerCase()).toList();
          if (_hintCategories.length != newHints.length ||
              !_hintCategories.every((element) => newHints.contains(element))) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hintCategories = newHints;
                });
              }
            });
          }
        }
      });
    });

    return Container(
      color: const Color(0xFF0D2226), // Seamless blend with AppBar
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Hero(
        tag: 'home_search_bar',
        child: Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onTap: () {
              context.go('/explore');
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  TypewriterHint(
                    prefix: 'Search \'',
                    texts: _hintCategories,
                    currentIndex: _currentHintIndex,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
