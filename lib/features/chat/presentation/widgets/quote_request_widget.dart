import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../quotes/data/models/quote_request_model.dart';
import '../../../quotes/presentation/providers/quotes_providers.dart';
import '../../data/models/message_model.dart';

class QuoteRequestWidget extends ConsumerWidget {
  final MessageModel? message;
  final String? quoteRequestId;

  const QuoteRequestWidget({super.key, this.message, this.quoteRequestId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Resolve ID from widget parameter, message payload, or fallback
    final rawId =
        (quoteRequestId != null &&
            quoteRequestId!.isNotEmpty &&
            quoteRequestId != '1')
        ? quoteRequestId
        : (message?.quoteRequest?['quoteRequestId']?.toString() ??
              message?.quoteRequest?['id']?.toString() ??
              message?.quoteRequest?['_id']?.toString() ??
              (quoteRequestId != '1' ? quoteRequestId : null));

    final bool hasValidId = rawId != null && rawId.isNotEmpty;

    // 2. Query API if a valid quoteRequestId exists
    final AsyncValue<QuoteRequestModel>? quoteDetailAsync = hasValidId
        ? ref.watch(quoteRequestDetailProvider(rawId))
        : null;
    final QuoteRequestModel? quoteDetail = quoteDetailAsync?.asData?.value;

    // 3. Extract dynamic business count
    final int? businessesAsked =
        quoteDetail?.vendorsAsked ??
        (quoteDetail?.vendors.isNotEmpty == true
            ? quoteDetail!.vendors.length
            : null) ??
        (message?.quoteRequest?['vendorsAsked'] as num?)?.toInt() ??
        (message?.quoteRequest?['businessesAsked'] as num?)?.toInt() ??
        (message?.quoteRequest?['businessCount'] as num?)?.toInt() ??
        (message?.quoteRequest?['vendorCount'] as num?)?.toInt() ??
        ((message?.quoteRequest?['items'] as List?)?.length) ??
        ((message?.quoteRequest?['vendors'] as List?)?.length);

    final String headerText;
    if (businessesAsked != null && businessesAsked > 0) {
      headerText = businessesAsked == 1
          ? 'QUOTE REQUEST · 1 BUSINESS ASKED'
          : 'QUOTE REQUEST · $businessesAsked BUSINESSES ASKED';
    } else {
      headerText = 'QUOTE REQUEST';
    }

    // 4. Extract dynamic event date
    DateTime? eventDate = quoteDetail?.eventDate;
    if (eventDate == null && message?.quoteRequest != null) {
      final rawDate =
          message!.quoteRequest!['eventDate'] ?? message!.quoteRequest!['date'];
      if (rawDate is DateTime) {
        eventDate = rawDate;
      } else if (rawDate != null) {
        eventDate = DateTime.tryParse(rawDate.toString());
      }
    }

    final String dateStr;
    if (eventDate != null) {
      dateStr = DateFormat('EEE, d MMMM yyyy').format(eventDate);
    } else if (quoteDetailAsync?.isLoading == true) {
      dateStr = 'Loading...';
    } else {
      dateStr = 'Date not specified';
    }

    // 5. Extract dynamic guest count
    final dynamic rawGuests =
        quoteDetail?.guestCount ??
        message?.quoteRequest?['guestCount'] ??
        message?.quoteRequest?['guests'];
    int? guestCount;
    if (rawGuests is num) {
      guestCount = rawGuests.toInt();
    } else if (rawGuests != null) {
      guestCount = int.tryParse(rawGuests.toString());
    }

    final String guestStr;
    if (guestCount != null && guestCount > 0) {
      guestStr = '$guestCount';
    } else if (quoteDetailAsync?.isLoading == true) {
      guestStr = '...';
    } else {
      guestStr = 'Not specified';
    }

    // 6. Extract dynamic requirements/notes
    final String? requirements =
        (quoteDetail?.requirements?.trim().isNotEmpty == true
            ? quoteDetail!.requirements
            : null) ??
        message?.quoteRequest?['message']?.toString() ??
        message?.quoteRequest?['requirements']?.toString() ??
        message?.quoteRequest?['notes']?.toString() ??
        message?.quoteRequest?['description']?.toString() ??
        message?.text;

    // 7. Extract dynamic location (if provided)
    final String? location =
        (quoteDetail?.location?.trim().isNotEmpty == true
            ? quoteDetail!.location
            : null) ??
        message?.quoteRequest?['eventLocation']?.toString() ??
        message?.quoteRequest?['location']?.toString();

    // 8. Extract dynamic budget (if provided)
    final num? budget =
        quoteDetail?.budget ??
        (message?.quoteRequest?['budget'] as num?) ??
        num.tryParse(message?.quoteRequest?['budget']?.toString() ?? '');

    // Show clean loading state only when API is loading and NO inline data is available yet
    if (quoteDetailAsync?.isLoading == true &&
        eventDate == null &&
        guestCount == null &&
        (requirements == null || requirements.trim().isEmpty)) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border.all(color: AppColors.borderStrong),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Businesses Asked
          Text(
            headerText,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),

          // Event Date
          Text(
            'Event date',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateStr,
            style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          // Guests
          Text(
            'Guests',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            guestStr,
            style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500),
          ),

          // Optional Location
          if (location != null && location.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Location',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              location.trim(),
              style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500),
            ),
          ],

          // Optional Budget
          if (budget != null && budget > 0) ...[
            const SizedBox(height: 16),
            Text(
              'Budget',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${NumberFormat('#,##,###').format(budget)}',
              style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500),
            ),
          ],

          // Requirements / Notes
          if (requirements != null && requirements.trim().isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(requirements.trim(), style: AppTextStyles.bodyMd),
          ],

          const SizedBox(height: 24),

          // CTA: Compare every business's quote
          Center(
            child: GestureDetector(
              onTap: () {
                if (hasValidId) {
                  context.pushNamed(
                    AppRoutes.quoteRequestDetails,
                    pathParameters: {'id': rawId},
                  );
                } else {
                  context.pushNamed(AppRoutes.quoteRequests);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Compare every business's quote",
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
