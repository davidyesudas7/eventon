import 'package:eventon/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../../../core/widgets/outlined_card.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../../../core/error/failures.dart';
import '../widgets/booking_status_badge.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_providers.dart';
import '../../../../core/services/razor_pay_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

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
  bool _isCreatingOrder = false;

  String? _advancePaymentError;
  String? _balancePaymentError;
  String? _reviewError;
  String? _disputeError;

  static const _payButtonColor = Color(0xFF155E56);

  @override
  void initState() {
    super.initState();
    _advanceController.addListener(() {
      if (_advancePaymentError != null) {
        setState(() => _advancePaymentError = null);
      }
    });
    _reviewController.addListener(() {
      if (_reviewError != null) {
        setState(() => _reviewError = null);
      }
    });
    _disputeController.addListener(() {
      if (_disputeError != null) {
        setState(() => _disputeError = null);
      }
    });

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
        try {
          await ref
              .read(payBookingProvider.notifier)
              .payBooking(id: widget.id, paymentData: paymentData);
        } catch (_) {}

        if (mounted) {
          setState(() {
            _paymentReceived = true;
            _advancePaymentError = null;
            _balancePaymentError = null;
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
          final errorMsg = extractErrorMessage(
            error,
            defaultMessage: 'Payment failed. Please try again.',
          );
          setState(() {
            _advancePaymentError = errorMsg;
            _balancePaymentError = errorMsg;
          });
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
    _razorpayService?.dispose();
    super.dispose();
  }

  Future<void> _payNow(
    BookingModel b,
    double amount, {
    required String purpose,
  }) async {
    if (amount <= 0 || _isCreatingOrder) return;

    setState(() {
      _isCreatingOrder = true;
      if (purpose == 'advance') {
        _advancePaymentError = null;
      } else {
        _balancePaymentError = null;
      }
    });

    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.createPaymentOrder(
      bookingId: b.id,
      purpose: purpose,
      amount: amount,
    );

    if (!mounted) return;
    setState(() => _isCreatingOrder = false);

    result.fold(
      (failure) {
        setState(() {
          if (purpose == 'advance') {
            _advancePaymentError = failure.message;
          } else {
            _balancePaymentError = failure.message;
          }
        });
      },
      (order) {
        final authState = ref.read(authControllerProvider);
        String? userEmail;
        String? userContact;
        if (authState is AuthStateAuthenticated) {
          userEmail = authState.user.email;
          userContact = authState.user.phone;
        }

        _razorpayService?.openCheckout(
          key: order.razorpayKeyId,
          orderId: order.razorpayOrderId,
          amount: order.amount,
          currency: order.currency,
          name: 'EventOn',
          description: purpose == 'advance'
              ? 'Advance Payment - ${b.serviceName}'
              : 'Balance Payment - ${b.serviceName}',
          prefillEmail: userEmail,
          prefillContact: userContact,
          notes: {
            'paymentOrderId': order.paymentOrderId,
            'bookingId': b.id,
            'purpose': purpose,
          },
        );
      },
    );
  }

  Future<void> _submitReview(BookingModel b) async {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) {
      setState(() => _reviewError = 'Please enter your review comment');
      return;
    }

    setState(() {
      _reviewError = null;
      _isSubmittingReview = true;
    });
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
        setState(() => _reviewError = failure.message);
      },
      (_) {
        setState(() => _reviewError = null);
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
      setState(() => _disputeError = 'Please describe the issue');
      return;
    }

    setState(() {
      _disputeError = null;
      _isSubmittingDispute = true;
    });
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.disputeBooking(
      bookingId: b.id,
      reason: reason,
    );
    if (!mounted) return;
    setState(() => _isSubmittingDispute = false);

    result.fold(
      (failure) {
        setState(() => _disputeError = failure.message);
      },
      (_) {
        setState(() {
          _disputeError = null;
          _showDisputeForm = false;
        });
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
    await showDialog<void>(
      context: context,
      builder: (ctx) => _CancelBookingDialog(
        booking: b,
        onCancel: (reason) async {
          final repo = ref.read(bookingRepositoryProvider);
          final result = await repo.cancelBooking(
            bookingId: b.id,
            reason: reason,
          );

          return result.fold(
            (failure) => failure.message,
            (_) {
              if (mounted) {
                ref.read(bookingDetailProvider(widget.id).notifier).refresh();
                ref.read(bookingsProvider.notifier).refresh();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled successfully'),
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
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
                          if (_advancePaymentError != null &&
                              _advancePaymentError!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            InlineErrorBanner(
                              message: _advancePaymentError,
                              margin: EdgeInsets.zero,
                              onDismiss: () =>
                                  setState(() => _advancePaymentError = null),
                            ),
                          ],
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
                                  onPressed: _isCreatingOrder
                                      ? null
                                      : () {
                                          final amount =
                                              double.tryParse(
                                                _advanceController.text.trim(),
                                              ) ??
                                              0;
                                          if (amount < b.minAdvance) {
                                            setState(() =>
                                                _advancePaymentError =
                                                    'Minimum advance is ${formatRupees(b.minAdvance.toInt())}');
                                            return;
                                          }
                                          _payNow(
                                            b,
                                            amount,
                                            purpose: 'advance',
                                          );
                                        },
                                  icon: _isCreatingOrder
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.lock_outline, size: 16),
                                  label: Text(
                                    _isCreatingOrder ? 'Processing…' : 'Pay now',
                                  ),
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
                            if (_balancePaymentError != null &&
                                _balancePaymentError!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              InlineErrorBanner(
                                message: _balancePaymentError,
                                margin: EdgeInsets.zero,
                                onDismiss: () =>
                                    setState(() => _balancePaymentError = null),
                              ),
                            ],
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
                                    onPressed: _isCreatingOrder
                                        ? null
                                        : () => _payNow(
                                              b,
                                              b.effectiveBalance,
                                              purpose: 'balance',
                                            ),
                                    icon: _isCreatingOrder
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.lock_outline, size: 16),
                                    label: Text(
                                      _isCreatingOrder ? 'Processing…' : 'Pay now',
                                    ),
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
                            if (_reviewError != null &&
                                _reviewError!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              InlineErrorBanner(
                                message: _reviewError,
                                margin: EdgeInsets.zero,
                                onDismiss: () =>
                                    setState(() => _reviewError = null),
                              ),
                            ],
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
                              if (_disputeError != null &&
                                  _disputeError!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                InlineErrorBanner(
                                  message: _disputeError,
                                  margin: EdgeInsets.zero,
                                  onDismiss: () =>
                                      setState(() => _disputeError = null),
                                ),
                              ],
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showDisputeForm = false;
                                        _disputeError = null;
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

class _CancelBookingDialog extends StatefulWidget {
  final BookingModel booking;
  final Future<String?> Function(String reason) onCancel;

  const _CancelBookingDialog({
    required this.booking,
    required this.onCancel,
  });

  @override
  State<_CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<_CancelBookingDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isCancelling = false;
  String? _dialogError;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      if (_dialogError != null) {
        setState(() => _dialogError = null);
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('Cancel booking?', style: AppTextStyles.headlineMd),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel "${widget.booking.serviceName}"?',
              style: AppTextStyles.bodyMd,
            ),
            const SizedBox(height: 16),
            Text(
              'Please tell us the reason:',
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              minLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g., Change of plans, change of venue…',
                hintStyle: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textSecondary,
                ),
                contentPadding: const EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.borderSubtle,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
            if (_dialogError != null && _dialogError!.isNotEmpty) ...[
              const SizedBox(height: 12),
              InlineErrorBanner(
                message: _dialogError,
                margin: EdgeInsets.zero,
                onDismiss: () => setState(() => _dialogError = null),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCancelling ? null : () => Navigator.pop(context),
          child: const Text('Keep booking'),
        ),
        ElevatedButton(
          onPressed: _isCancelling
              ? null
              : () async {
                  final reason = _reasonController.text.trim();
                  if (reason.isEmpty) {
                    setState(() =>
                        _dialogError = 'Please provide a reason for cancellation');
                    return;
                  }

                  setState(() {
                    _isCancelling = true;
                    _dialogError = null;
                  });
                  final navigator = Navigator.of(context);
                  final error = await widget.onCancel(reason);
                  if (mounted) {
                    if (error != null) {
                      setState(() {
                        _isCancelling = false;
                        _dialogError = error;
                      });
                    } else {
                      navigator.pop();
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isCancelling
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Cancel booking'),
        ),
      ],
    );
  }
}

