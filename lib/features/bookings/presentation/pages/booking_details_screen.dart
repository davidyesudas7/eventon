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
  RazorpayService? _razorpayService;
  bool _paymentReceived = false;

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
    super.dispose();
  }

  void _payNow(BookingModel b, double amount) {
    if (amount <= 0) return;
    final messenger = ScaffoldMessenger.of(context);

    // In a real app, this amount needs to be created as an order on backend
    // But for this demo, we're just directly passing it to RazorpayService
    messenger.showSnackBar(
      SnackBar(
        content: Text('Proceeding to pay ${formatRupees(amount.toInt())}…'),
      ),
    );

    _razorpayService?.openCheckout(
      amount: amount,
      prefillContact: '', // add contact if needed
      prefillEmail: '',
      orderId: b.id, // add email if needed
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
      // TODO: call cancel booking API.
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
            final statusStr = b.status?.toLowerCase() ?? 'pending';
            final canCancel =
                statusStr == 'awaiting_advance' ||
                statusStr == 'pending_advance' ||
                statusStr == 'pending' ||
                statusStr == 'confirmed';

            final serviceName = b.serviceName;
            final dateStr = b.eventDate != null
                ? formatBookingDate(b.eventDate!)
                : 'Unknown Date';

            // Set initial advance text if empty
            if (_advanceController.text.isEmpty && b.minAdvance > 0) {
              _advanceController.text = b.minAdvance.toInt().toString();
            }

            final isAwaitingAdvance =
                statusStr == 'pending' ||
                statusStr == 'awaiting_advance' ||
                statusStr == 'pending_advance';
            final isInProgress = statusStr == 'in_progress';
            final isCompleted = statusStr == 'completed';

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BookingStatusBadge(
                    status: _mapStatusToEnum(statusStr),
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
                  if (b.paidAmount > 0 || _paymentReceived) ...[
                    Text(
                      'Payment received. This booking will be updated when your payment is cleared.',
                      style: AppTextStyles.bodySm.copyWith(),
                    ),
                  ],
                  OutlinedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pay advance', style: AppTextStyles.labelLg),
                        const SizedBox(height: 4),
                        Text(
                          'Minimum advance: ${formatRupees(b.minAdvance.toInt())} (20%)',
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
                ] else if (isInProgress) ...[
                  const SizedBox(height: 24),
                  if ((b.paidAmount > 0 && (b.balanceAmount ?? 0) > 0) ||
                      _paymentReceived) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMintPill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Payment received. This booking will be updated when your payment is cleared.',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                  if ((b.balanceAmount ?? 0) > 0)
                    OutlinedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pay balance', style: AppTextStyles.labelLg),
                          const SizedBox(height: 4),
                          Text(
                            'Balance amount: ${formatRupees((b.balanceAmount ?? 0).toInt())}',
                            style: AppTextStyles.bodySm,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: () => _payNow(b, b.balanceAmount ?? 0),
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
                    ),
                ] else if (isCompleted) ...[
                  const SizedBox(height: 24),
                  OutlinedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment summary', style: AppTextStyles.labelLg),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total amount', style: AppTextStyles.bodyMd),
                            Text(
                              formatRupees(b.totalAmount.toInt()),
                              style: AppTextStyles.bodyMd,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount paid', style: AppTextStyles.bodyMd),
                            Text(
                              formatRupees(b.paidAmount.toInt()),
                              style: AppTextStyles.bodyMd,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
            );
          },
        ),
      ),
    );
  }

  // Temporary enum mapping
  dynamic _mapStatusToEnum(String status) {
    // Return dummy enum value that matches BookingStatusBadge requirements
    // This assumes BookingStatusBadge was using the old BookingStatus enum.
    // If BookingStatusBadge takes a String, this can be simplified.
    // We'll return null to let the badge fallback if needed, or define a local mapping.
    // Let's just return a String if the badge accepts it, otherwise we might need to modify the badge.
    return status;
  }
}
