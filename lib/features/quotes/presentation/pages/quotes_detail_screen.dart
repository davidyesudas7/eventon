import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/quotes_providers.dart';

class QuotesDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const QuotesDetailScreen({super.key, required this.id});

  @override
  ConsumerState<QuotesDetailScreen> createState() => _QuotesDetailScreenState();
}

class _QuotesDetailScreenState extends ConsumerState<QuotesDetailScreen> {
  bool _showCloseConfirmation = false;
  bool _isClosing = false;

  Future<void> _closeRequest() async {
    setState(() => _isClosing = true);
    final repo = ref.read(quotesRepositoryProvider);
    final res = await repo.closeQuoteRequest(widget.id);
    
    if (mounted) {
      setState(() => _isClosing = false);
      res.fold(
        (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message))),
        (r) {
          setState(() => _showCloseConfirmation = false);
          ref.invalidate(quoteRequestDetailProvider(widget.id));
          ref.invalidate(quoteRequestsProvider);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(quoteRequestDetailProvider(widget.id));

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
      body: detailAsync.when(
        data: (item) {
          int quotedCount = item.vendors.where((v) => v.state == 'quoted' || v.status == 'quoted' || v.latestQuote != null).length;
          int totalCount = item.vendors.length;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(quoteRequestDetailProvider(widget.id));
              await ref.read(quoteRequestDetailProvider(widget.id).future);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Back',
                          style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderSubtle),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your quote request',
                              style: AppTextStyles.headlineMd.copyWith(fontSize: 18),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: item.status?.toLowerCase() == 'closed'
                                    ? AppColors.surfaceMuted
                                    : const Color(0xFFE5F1EF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                item.status?.toLowerCase() == 'closed' ? 'Closed' : (item.status ?? 'Open'),
                                style: AppTextStyles.labelSm.copyWith(
                                  color: item.status?.toLowerCase() == 'closed'
                                      ? AppColors.textSecondary
                                      : const Color(0xFF155E56),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(
                              item.eventDate != null
                                  ? DateFormat('EEE, d MMMM yyyy').format(item.eventDate!)
                                  : 'No date',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.group_outlined, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(
                              '${item.guestCount ?? 0} guests',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.requirements ?? '',
                          style: AppTextStyles.bodyMd,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$quotedCount of $totalCount businesses have quoted so far.',
                          style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...item.vendors.map((vendor) {
                    String displayState = 'Waiting for a quote';
                    if (vendor.state == 'quoted' || vendor.status == 'quoted' || vendor.latestQuote != null) {
                      displayState = 'Quoted';
                    } else if (vendor.state == 'awaiting_quote') {
                      displayState = 'Waiting for a quote';
                    } else {
                      displayState = vendor.state ?? vendor.status ?? 'Waiting for a quote';
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderSubtle),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: vendor.coverUrl != null
                                ? Image.network(
                                    vendor.coverUrl!,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    color: AppColors.surfaceMuted,
                                    child: const Icon(Icons.business),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        vendor.name ?? 'Unknown',
                                        style: AppTextStyles.bodyLg.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE5E7EB),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        displayState,
                                        style: AppTextStyles.labelSm.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vendor.subtitle ?? 'Provider',
                                  style: AppTextStyles.labelMd.copyWith(
                                    color: const Color(0xFF3279A8),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      if (vendor.conversationId != null) {
                                        context.push('/chats/${vendor.conversationId}');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Chat not available yet.')),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                    label: const Text('Chat'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.textPrimary,
                                      side: const BorderSide(color: AppColors.borderSubtle),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      minimumSize: const Size(0, 36),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (item.status?.toLowerCase() != 'closed') ...[
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 24),
                    if (!_showCloseConfirmation) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCloseConfirmation = true;
                          });
                        },
                        child: Text(
                          'Close this request',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'When you have what you need. Bookings you made stay as they are.',
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderSubtle),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Close it? Any quote you have not answered is declined, and businesses who have not quoted are told you are done.',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _showCloseConfirmation = false;
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.textPrimary,
                                      side: const BorderSide(color: AppColors.borderStrong),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text('Keep open'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isClosing ? null : _closeRequest,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF132329),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: _isClosing 
                                      ? const SizedBox(
                                          width: 20, 
                                          height: 20, 
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                        )
                                      : const Text('Close request'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
