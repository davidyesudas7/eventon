import 'package:eventon/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/widgets/outlined_card.dart';
import '../widgets/booking_status_badge.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_providers.dart';
import '../../../../core/services/razor_pay_service.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  const BookingDetailsScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen> {
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _disputeController = TextEditingController();

  RazorpayService? _razorpayService;
  bool _paymentReceived = false;
  int _selectedRating = 5;
  bool _isSubmittingReview = false;
  bool _isSubmittingDispute = false;
  bool _showDisputeForm = false;

  static const _payButtonColor = Color(0xFF155E56);

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService(
      onExternalWallet: (response) {
        // Handle external wallet
      },
      onSuccess: (response) async {
        final paymentData = {
          'razorpay_payment_id': response.paymentId,
          'razorpay_order_id': response.orderId,
          'razorpay_signature': response.signature,
        };
        await ref
            .read(payBookingProvider.notifier)
            .payBooking(id: widget.id, paymentData: paymentData);
        if (mounted) {
          setState(() {
            _paymentReceived = true;
          });
          ref.read(bookingDetailProvider(widget.id).notifier).refresh();
          ref.read(bookingsProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment received successfully')),
          );
        }
      },
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
        }
      },
    );
  }

  @override
  void dispose() {
    _advanceController.dispose();
    _balanceController.dispose();
    _reviewController.dispose();
    _disputeController.dispose();
    super.dispose();
  }

  void _payNow(BookingModel b, double amount) {
    if (amount <= 0) return;
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text('Proceeding to pay ${formatRupees(amount.toInt())}…'),
      ),
    );

    _razorpayService?.openCheckout(
      amount: amount,
      prefillContact: '',
      prefillEmail: '',
      orderId: b.id,
    );
  }

  Future<void> _submitReview(BookingModel b) async {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your review comment')),
      );
      return;
    }

    setState(() => _isSubmittingReview = true);
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.createReview(
      bookingId: b.id,
      rating: _selectedRating.toDouble(),
      comment: comment,
    );
    if (!mounted) return;
    setState(() => _isSubmittingReview = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        _reviewController.clear();
        ref.read(bookingDetailProvider(widget.id).notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      },
    );
  }

  Future<void> _submitDispute(BookingModel b) async {
    final reason = _disputeController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue')),
      );
      return;
    }

    setState(() => _isSubmittingDispute = true);
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.disputeBooking(
      bookingId: b.id,
      reason: reason,
    );
    if (!mounted) return;
    setState(() => _isSubmittingDispute = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        setState(() => _showDisputeForm = false);
        _disputeController.clear();
        ref.read(bookingDetailProvider(widget.id).notifier).refresh();
        ref.read(bookingsProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Issue reported. Our team will review this booking.'),
          ),
        );
      },
    );
  }

  Future<void> _cancelBooking(BookingModel b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Cancel booking?', style: AppTextStyles.headlineMd),
        content: Text(
          'Are you sure you want to cancel "${b.serviceName}"?',
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(bookingDetailProvider(widget.id));
    final isPaying = ref.watch(payBookingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(fallbackLocation: '/bookings'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: bookingAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Failed to load booking', style: AppTextStyles.headlineSm),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(bookingDetailProvider(widget.id).notifier)
                      .refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (b) {
            final isAwaitingAdvance = b.isPendingAdvance;
            final isConfirmed = b.isConfirmed;
            final isInProgress = b.isInProgress;
            final isCompleted = b.isCompleted;
            final isDisputed = b.isDisputed;
            final canCancel =
                (isAwaitingAdvance || isConfirmed) && !isDisputed;

            final serviceName = b.serviceName;
            final dateStr = b.eventDate != null
                ? formatBookingDate(b.eventDate!)
                : 'Unknown Date';

            // Set initial advance text if empty
            if (_advanceController.text.isEmpty && b.minAdvance > 0) {
              _advanceController.text = b.minAdvance.toInt().toString();
            }
            _balanceController.text = b.effectiveBalance.toInt().toString();

            return RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(bookingDetailProvider(widget.id).notifier)
                    .refresh();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                children: [
                  if (isDisputed)
                    Text('Disputed', style: AppTextStyles.headlineMd)
                  else if (isCompleted)
                    Text('Completed', style: AppTextStyles.headlineMd)
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BookingStatusBadge(
                        status: b.status ?? 'pending_advance',
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Summary card
                  OutlinedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(serviceName, style: AppTextStyles.bodyMd),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(dateStr, style: AppTextStyles.bodyMd),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatRupees(b.totalAmount.toInt()),
                          style: AppTextStyles.headlineMd,
                        ),
                        if (isCompleted || isDisputed) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Advance paid: ${formatRupees(b.paidAmount.toInt())}',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Balance settled: ${formatRupees(b.effectiveBalance.toInt())}',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (isPaying)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (isAwaitingAdvance) ...[
                    const SizedBox(height: 15),
                    if (_paymentReceived) ...[
                      Text(
                        'Payment received. This booking will be updated when your payment is cleared.',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    OutlinedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pay advance', style: AppTextStyles.labelLg),
                          const SizedBox(height: 4),
                          Text(
                            'Minimum advance: ${formatRupees(b.minAdvance.toInt())} (${b.minAdvancePercent?.toInt() ?? 20}%)',
                            style: AppTextStyles.bodySm,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _advanceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: AppTextStyles.bodyLg.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.borderSubtle,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 46,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    final amount =
                                        double.tryParse(
                                          _advanceController.text.trim(),
                                        ) ??
                                        0;
                                    if (amount < b.minAdvance) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Minimum advance is ${formatRupees(b.minAdvance.toInt())}',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    _payNow(b, amount);
                                  },
                                  icon: const Icon(Icons.lock_outline, size: 16),
                                  label: const Text('Pay now'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _payButtonColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                    ),
                                    shape: const StadiumBorder(),
                                    textStyle: AppTextStyles.labelLg.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else if (isConfirmed) ...[
                    const SizedBox(height: 16),
                    OutlinedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Advance captured', style: AppTextStyles.labelLg),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Advance paid', style: AppTextStyles.bodyMd),
                              Text(
                                formatRupees(b.paidAmount.toInt()),
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remaining balance', style: AppTextStyles.bodyMd),
                              Text(
                                formatRupees(b.effectiveBalance.toInt()),
                                style: AppTextStyles.bodyMd,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Your booking is confirmed! The balance payment can be settled on the event day.',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (isInProgress) ...[
                    const SizedBox(height: 24),
                    if (_paymentReceived) ...[
                      Text(
                        'Payment received. This booking will be updated when your payment is cleared.',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (b.effectiveBalance > 0)
                      OutlinedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pay balance', style: AppTextStyles.labelLg),
                            const SizedBox(height: 4),
                            Text(
                              'Balance amount: ${formatRupees(b.effectiveBalance.toInt())}',
                              style: AppTextStyles.bodySm,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _balanceController,
                                    readOnly: true,
                                    keyboardType: TextInputType.number,
                                    style: AppTextStyles.bodyLg.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.borderSubtle,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.borderSubtle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 46,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _payNow(b, b.effectiveBalance),
                                    icon: const Icon(
                                      Icons.lock_outline,
                                      size: 16,
                                    ),
                                    label: const Text('Pay now'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _payButtonColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                      ),
                                      shape: const StadiumBorder(),
                                      textStyle: AppTextStyles.labelLg.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      OutlinedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment status', style: AppTextStyles.labelLg),
                            const SizedBox(height: 8),
                            Text(
                              'Balance is settled. The event is in progress.',
                              style: AppTextStyles.bodyMd,
                            ),
                          ],
                        ),
                      ),
                  ] else if (isDisputed) ...[
                    const SizedBox(height: 24),
                    Text(
                      'This booking is under review by our team.',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ] else if (isCompleted) ...[
                    if (b.isDisputeResolved) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 18,
                              color: Color(0xFF155E56),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Dispute resolved: ${b.disputeResolution ?? 'Resolved by our team'}',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: const Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (b.reviewedAt == null) ...[
                      const SizedBox(height: 24),
                      OutlinedCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leave a review',
                              style: AppTextStyles.labelLg.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: List.generate(5, (index) {
                                final isSelected = index < _selectedRating;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRating = index + 1;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Icon(
                                      isSelected
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      size: 28,
                                      color: const Color(0xFF155E56),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _reviewController,
                              maxLines: 4,
                              minLines: 3,
                              decoration: InputDecoration(
                                hintText: 'How did it go?',
                                hintStyle: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.borderSubtle,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF155E56),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _isSubmittingReview
                                    ? null
                                    : () => _submitReview(b),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF155E56),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: AppTextStyles.labelLg.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: _isSubmittingReview
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Submit review'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: Color(0xFF155E56),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'You reviewed this booking',
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (b.disputedAt == null) ...[
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDisputeForm = !_showDisputeForm;
                            });
                          },
                          child: Text(
                            'Report an issue with this booking',
                            style: AppTextStyles.bodySm.copyWith(
                              color: const Color(0xFF475569),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),

                      if (_showDisputeForm) ...[
                        const SizedBox(height: 16),
                        OutlinedCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report an issue',
                                style: AppTextStyles.labelLg.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Describe what went wrong with this booking.',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _disputeController,
                                maxLines: 4,
                                minLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'What went wrong?',
                                  hintStyle: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  contentPadding: const EdgeInsets.all(14),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.borderSubtle,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showDisputeForm = false;
                                      });
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: _isSubmittingDispute
                                        ? null
                                        : () => _submitDispute(b),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFC2410C),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: _isSubmittingDispute
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('Submit report'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],

                  if (canCancel) ...[
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => _cancelBooking(b),
                        child: Text(
                          'Cancel booking',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: const Color(0xFFC2410C),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
