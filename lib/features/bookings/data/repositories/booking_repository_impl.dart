import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_model.dart';
import '../models/payment_order_model.dart';
import '../../../listings/data/models/review_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final ApiClient apiClient;

  BookingRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, BookingModel>> createDirectBooking({
    required String packageId,
    required DateTime eventDate,
  }) async {
    try {
      final result = await apiClient.createDirectBooking({
        'packageId': packageId,
        'eventDate': eventDate.toIso8601String(),
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ??
              e.message ??
              'Failed to create booking',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingModel>>> getBookings() async {
    try {
      final result = await apiClient.getBookings();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'Failed to get bookings',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingModel>> getBookingById(String id) async {
    try {
      final result = await apiClient.getBookingById(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'Failed to get booking',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingModel>> payBooking({
    required String id,
    required Map<String, dynamic> paymentData,
  }) async {
    try {
      final result = await apiClient.payBooking(id, paymentData);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ?? e.message ?? 'Failed to pay booking',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> createReview({
    required String bookingId,
    required double rating,
    required String comment,
  }) async {
    try {
      final result = await apiClient.createReview({
        'bookingId': bookingId,
        'rating': rating,
        'comment': comment,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ??
              e.message ??
              'Failed to submit review',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingModel>> disputeBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final result = await apiClient.disputeBooking(bookingId, {
        'reason': reason,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ??
              e.message ??
              'Failed to report issue',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentOrderModel>> createPaymentOrder({
    required String bookingId,
    required String purpose,
    required double amount,
  }) async {
    try {
      final result = await apiClient.createPaymentOrder({
        'bookingId': bookingId,
        'purpose': purpose,
        'amount': amount,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ??
              e.message ??
              'Failed to create payment order',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingModel>> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final result = await apiClient.cancelBooking(bookingId, {
        'reason': reason,
      });
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          e.response?.data['message'] ??
              e.message ??
              'Failed to cancel booking',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
