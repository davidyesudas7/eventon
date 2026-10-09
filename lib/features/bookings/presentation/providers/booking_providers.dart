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
    if (!ref.mounted) return [];
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.getBookings();
    if (!ref.mounted) return [];
    return result.fold((l) => throw l, (r) => r);
  }

  Future<void> refresh() async {
    if (!ref.mounted) return;
    state = const AsyncValue.loading();
    final res = await AsyncValue.guard(_fetchBookings);
    if (!ref.mounted) return;
    state = res;
  }
}

@riverpod
class BookingDetailNotifier extends _$BookingDetailNotifier {
  @override
  FutureOr<BookingModel> build(String id) async {
    return _fetchBooking(id);
  }

  Future<BookingModel> _fetchBooking(String id) async {
    if (!ref.mounted) throw 'Disposed';
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.getBookingById(id);
    if (!ref.mounted) throw 'Disposed';
    return result.fold((l) => throw l, (r) => r);
  }

  Future<void> refresh() async {
    if (!ref.mounted) return;
    state = const AsyncValue.loading();
    final res = await AsyncValue.guard(() => _fetchBooking(id));
    if (!ref.mounted) return;
    state = res;
  }
}

@riverpod
class CreateBookingNotifier extends _$CreateBookingNotifier {
  @override
  bool build() => false;

  String? lastError;

  Future<BookingModel?> createBooking({
    required String listingId,
    required String packageId,
    required DateTime eventDate,
  }) async {
    lastError = null;
    state = true;
    final repo = ref.read(bookingRepositoryProvider);
    final result = await repo.createDirectBooking(
      packageId: packageId,
      eventDate: eventDate,
    );
    if (!ref.mounted) return null;
    state = false;

    return result.fold(
      (l) {
        lastError = l.message;
        return null;
      },
      (r) {
        if (ref.mounted) {
          ref.invalidate(bookingsProvider);
        }
        return r;
      },
    );
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
    if (!ref.mounted) return false;
    state = false;

    return result.fold((l) => false, (r) {
      if (ref.mounted) {
        ref.invalidate(bookingDetailProvider(id));
        ref.invalidate(bookingsProvider);
      }
      return true;
    });
  }
}
