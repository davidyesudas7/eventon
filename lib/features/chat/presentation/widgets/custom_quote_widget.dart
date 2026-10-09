import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/message_model.dart';
import '../providers/chat_providers.dart';

class CustomQuoteWidget extends ConsumerStatefulWidget {
  final MessageModel message;
  final String conversationId;
  final bool isMe;

  const CustomQuoteWidget({
    super.key,
    required this.message,
    required this.conversationId,
    required this.isMe,
  });

  @override
  ConsumerState<CustomQuoteWidget> createState() => _CustomQuoteWidgetState();
}

class _CustomQuoteWidgetState extends ConsumerState<CustomQuoteWidget> {
  bool _isAccepting = false;
  bool _isDeclining = false;

  Future<void> _handleResponse(bool accept) async {
    if (_isAccepting || _isDeclining) return;

    setState(() {
      if (accept) {
        _isAccepting = true;
      } else {
        _isDeclining = true;
      }
    });

    try {
      final updatedMessage = await ref
          .read(chatDetailProvider(widget.conversationId).notifier)
          .respondToQuote(messageId: widget.message.id, accept: accept);

      if (!mounted) return;

      // Accepting opens a booking; take the customer straight to it
      final bookingId = updatedMessage.quote?['bookingId']?.toString();
      if (accept && bookingId != null && bookingId.isNotEmpty) {
        context.push('/bookings/$bookingId');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept
                ? 'Could not accept this quote: ${e.toString()}'
                : 'Could not decline this quote: ${e.toString()}',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAccepting = false;
          _isDeclining = false;
        });
      }
    }
  }

  String _formatDate(dynamic rawDate, DateTime fallback) {
    if (rawDate != null) {
      final parsed = DateTime.tryParse(rawDate.toString());
      if (parsed != null) {
        return DateFormat('d MMM yyyy').format(parsed).toUpperCase();
      }
    }
    return DateFormat('d MMM yyyy').format(fallback).toUpperCase();
  }

  String _formatCurrency(num amount) {
    return NumberFormat('#,##,###').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final quote = widget.message.quote ?? {};
    final amount = (quote['amount'] as num?) ?? 0;
    final description = quote['description']?.toString() ?? 'Custom Quote';
    final status = quote['status']?.toString().toLowerCase() ?? 'pending';
    final bookingId = quote['bookingId']?.toString();
    final eventDateStr = _formatDate(
      quote['eventDate'],
      widget.message.createdAt,
    );

    final isPending = status == 'pending';
    final isAccepted = status == 'accepted';
    final isRejected = status == 'rejected';

    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: widget.isMe ? 48 : 16,
          right: widget.isMe ? 16 : 48,
          top: 6,
          bottom: 12,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A000000),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Header: CUSTOM QUOTE · DATE
            Text(
              'CUSTOM QUOTE · $eventDateStr',
              style: AppTextStyles.labelSm.copyWith(
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 16),

            // 2. Title / Description
            Text(
              description,
              style: AppTextStyles.bodyMd.copyWith(
                color: const Color(0xFF4B5563),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),

            // 3. Amount and 'total'
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '₹${_formatCurrency(amount)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15272A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'total',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Action buttons or Status footer
            if (isPending && !widget.isMe) ...[
              Row(
                children: [
                  // Decline Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (_isAccepting || _isDeclining)
                          ? null
                          : () => _handleResponse(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.white,
                      ),
                      child: _isDeclining
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Decline',
                              style: TextStyle(
                                color: Color(0xFF1F2937),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Accept Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_isAccepting || _isDeclining)
                          ? null
                          : () => _handleResponse(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF155E56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: _isAccepting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Accept quote',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ] else if (isAccepted) ...[
              Row(
                children: [
                  const Text(
                    'ACCEPTED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.8,
                    ),
                  ),
                  if (bookingId != null && bookingId.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        context.push('/bookings/$bookingId');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View booking',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF155E56),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 18,
                            color: Color(0xFF155E56),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ] else if (isRejected) ...[
              const Text(
                'REJECTED',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.8,
                ),
              ),
            ] else ...[
              const Text(
                'PENDING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
