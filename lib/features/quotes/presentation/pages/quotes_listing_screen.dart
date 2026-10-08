import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/quotes_providers.dart';

class QuotesListingScreen extends ConsumerWidget {
  const QuotesListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteRequestsAsync = ref.watch(quoteRequestsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'EventOn',
          style: TextStyle(
            color: Color(0xFF155E56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quote requests',
                  style: AppTextStyles.headlineMd.copyWith(fontSize: 22),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to explore to make a new request
                    context.go('/explore');
                  },
                  child: Text(
                    'New request',
                    style: AppTextStyles.labelMd.copyWith(
                      color: const Color(0xFF155E56),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),
          Expanded(
            child: quoteRequestsAsync.when(
              data: (result) {
                if (result.isEmpty) {
                  return const Center(child: Text('No quote requests yet.'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(quoteRequestsProvider);
                    await ref.read(quoteRequestsProvider.future);
                  },
                  child: ListView.separated(
                    itemCount: result.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: AppColors.borderSubtle),
                    itemBuilder: (context, index) {
                      final item = result[index];
                      int quotedCount = item.quotesReceived ?? 
                          item.vendors.where((v) => v.state == 'quoted' || v.status == 'quoted' || v.latestQuote != null).length;
                      int totalCount = item.vendorsAsked ?? item.vendors.length;

                      return InkWell(
                        onTap: () {
                          context.push('/quote-requests/${item.id}');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.eventDate != null
                                          ? 'For ${DateFormat('d MMM yyyy').format(item.eventDate!)}'
                                          : 'No date specified',
                                      style: AppTextStyles.bodyLg.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.requirements ?? 'No details',
                                      style: AppTextStyles.bodyMd.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.status?.toLowerCase() == 'closed'
                                          ? '$quotedCount of $totalCount quoted · closed'
                                          : '$quotedCount of $totalCount quoted',
                                      style: AppTextStyles.labelMd.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
