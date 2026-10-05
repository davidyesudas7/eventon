import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';

class _SearchCategory {
  const _SearchCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

const _categories = [
  _SearchCategory('Bridal makeup & styling', Icons.auto_awesome_outlined),
  _SearchCategory('Bridal wear & costumes', Icons.checkroom_outlined),
  _SearchCategory('Cakes & desserts', Icons.cake_outlined),
  _SearchCategory('Catering', Icons.room_service_outlined),
  _SearchCategory('DJ & entertainment', Icons.headphones_outlined),
  _SearchCategory('Decoration & stage', Icons.celebration_outlined),
  _SearchCategory('Event & wedding planners', Icons.event_available_outlined),
  _SearchCategory('Invitations & printing', Icons.mail_outline),
  _SearchCategory("Kids' party entertainment", Icons.child_care_outlined),
  _SearchCategory('Mehendi artists', Icons.back_hand_outlined),
  _SearchCategory('Pandal, tent & furniture', Icons.festival_outlined),
  _SearchCategory('Photography & videography', Icons.camera_alt_outlined),
  _SearchCategory('Travel & transport', Icons.directions_car_outlined),
  _SearchCategory('Venues', Icons.location_city_outlined),
];

/// Search sub-screen of Explore (`/explore/search`).
///
/// Opened as soon as the user starts typing in the Explore search bar.
/// Clearing the query pops back to Explore. Selecting a suggestion pops
/// back with the selected term as the result.
class ExploreSearchScreen extends StatefulWidget {
  const ExploreSearchScreen({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<ExploreSearchScreen> createState() => _ExploreSearchScreenState();
}

class _ExploreSearchScreenState extends State<ExploreSearchScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.initialQuery);
  final FocusNode _focusNode = FocusNode();
  bool _closing = false;

  String get _query => _controller.text.trim();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _close([String? result]) {
    if (_closing) return;
    _closing = true;
    FocusScope.of(context).unfocus();
    if (context.canPop()) {
      context.pop(result);
    } else {
      context.go('/explore');
    }
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      _close();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final matches = q.isEmpty ? <_SearchCategory>[] : _categories.where((c) => c.label.toLowerCase().contains(q)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: EventOnAppBar(onBack: _close),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 3)),
              ],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: (v) => v.trim().isEmpty ? null : _close(v.trim()),
              style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
                  onPressed: () {
                    _controller.clear();
                    _close();
                  },
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Location chip
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 6),
                  Text('Current location · 25 km', style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // "Search for" row
          if (_query.isNotEmpty)
            _SuggestionTile(
              icon: Icons.search,
              label: 'Search for “$_query”',
              onTap: () => _close(_query),
            ),

          if (matches.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                'CATEGORIES',
                style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500, letterSpacing: 0.6),
              ),
            ),
            for (final c in matches)
              _SuggestionTile(
                icon: c.icon,
                label: c.label,
                labelColor: AppColors.textPrimary,
                onTap: () => _close(c.label),
              ),
          ],
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.icon, required this.label, required this.onTap, this.labelColor});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLg.copyWith(fontSize: 15, color: labelColor ?? AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
