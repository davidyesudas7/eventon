import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_providers.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_providers.g.dart';

@riverpod
BookingRepository bookingRepository(Ref ref) {
  return BookingRepositoryImpl(apiClient: ref.watch(apiClientProvider));
}

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  @override
  FutureOr<List<BookingModel>> build() async {
    return _fetchBookings();
  }

  Future<List<BookingModel>> _fetchBookings() async {
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.getBookings();
    return result.fold((l) => throw l, (r) => r);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchBookings);
  }
}

@riverpod
class BookingDetailNotifier extends _$BookingDetailNotifier {
  @override
  FutureOr<BookingModel> build(String id) async {
    return _fetchBooking(id);
  }

  Future<BookingModel> _fetchBooking(String id) async {
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.getBookingById(id);
    return result.fold((l) => throw l, (r) => r);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchBooking(id));
  }
}

@riverpod
class CreateBookingNotifier extends _$CreateBookingNotifier {
  @override
  bool build() => false;

  Future<BookingModel?> createBooking({
    required String listingId,
    required String packageId,
    required DateTime eventDate,
  }) async {
    state = true;
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.createDirectBooking(
      packageId: packageId,
      eventDate: eventDate,
    );
    state = false;

    return result.fold((l) => null, (r) {
      ref.invalidate(bookingsProvider);
      return r;
    });
  }
}

@riverpod
class PayBookingNotifier extends _$PayBookingNotifier {
  @override
  bool build() => false;

  Future<bool> payBooking({
    required String id,
    required Map<String, dynamic> paymentData,
  }) async {
    state = true;
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.payBooking(id: id, paymentData: paymentData);
    state = false;

    return result.fold((l) => false, (r) {
      ref.invalidate(bookingDetailProvider(id));
      ref.invalidate(bookingsProvider);
      return true;
    });
  }
}
