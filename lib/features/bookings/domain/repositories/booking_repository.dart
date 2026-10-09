import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/booking_model.dart';
import '../../../listings/data/models/review_model.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingModel>> createDirectBooking({
    required String packageId,
    required DateTime eventDate,
  });

  Future<Either<Failure, List<BookingModel>>> getBookings();

  Future<Either<Failure, BookingModel>> getBookingById(String id);

  Future<Either<Failure, BookingModel>> payBooking({
    required String id,
    required Map<String, dynamic> paymentData,
  });

  Future<Either<Failure, ReviewModel>> createReview({
    required String bookingId,
    required double rating,
    required String comment,
  });

  Future<Either<Failure, BookingModel>> disputeBooking({
    required String bookingId,
    required String reason,
  });
}
