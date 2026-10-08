import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_model.dart';

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
}
