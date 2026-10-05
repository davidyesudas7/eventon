import 'package:eventon/core/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/eventon_app_bar.dart';
import '../../domain/entities/booking.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late final TextEditingController _advanceController = TextEditingController(
    text: widget.booking.minAdvance.toString(),
  );

  static const _payButtonColor = Color(0xFF155E56);

  @override
  void dispose() {
    _advanceController.dispose();
    super.dispose();
  }

  void _payNow() {
    final b = widget.booking;
    final amount = int.tryParse(_advanceController.text.trim());
    final messenger = ScaffoldMessenger.of(context);
    String? error;
    if (amount == null) {
      error = 'Enter a valid amount';
    } else if (amount < b.minAdvance) {
      error = 'Minimum advance is ${formatRupees(b.minAdvance)}';
    } else if (amount > b.amount) {
      error = 'Advance cannot exceed ${formatRupees(b.amount)}';
    }
    FocusScope.of(context).unfocus();
    messenger.showSnackBar(
      SnackBar(
        content: Text(error ?? 'Proceeding to pay ${formatRupees(amount!)}…'),
      ),
    );
    // TODO: integrate payment gateway.
  }

  Future<void> _cancelBooking() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Cancel booking?', style: AppTextStyles.headlineMd),
        content: Text(
          'Are you sure you want to cancel "${widget.booking.serviceName}"?',
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
    final b = widget.booking;
    final canCancel =
        b.status == BookingStatus.awaitingAdvance ||
        b.status == BookingStatus.confirmed;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const EventOnAppBar(fallbackLocation: '/bookings'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            Text(b.status.label, style: AppTextStyles.headlineMd),
            const SizedBox(height: 16),

            // Summary card
            _OutlinedCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.serviceName, style: AppTextStyles.bodyMd),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        formatBookingDate(b.date),
                        style: AppTextStyles.bodyMd,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(formatRupees(b.amount), style: AppTextStyles.headlineMd),
                ],
              ),
            ),

            if (b.status == BookingStatus.awaitingAdvance) ...[
              const SizedBox(height: 24),
              _OutlinedCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pay advance', style: AppTextStyles.labelLg),
                    const SizedBox(height: 4),
                    Text(
                      'Minimum advance: ${formatRupees(b.minAdvance)} (${b.minAdvancePercent}%)',
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
                            onPressed: _payNow,
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
            ],

            if (canCancel) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _cancelBooking,
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
      ),
    );
  }
}

class _OutlinedCard extends StatelessWidget {
  const _OutlinedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: child,
    );
  }
}
