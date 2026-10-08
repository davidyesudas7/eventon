import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/booking_model.dart';

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
}
