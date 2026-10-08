// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookingRepository)
final bookingRepositoryProvider = BookingRepositoryProvider._();

final class BookingRepositoryProvider
    extends
        $FunctionalProvider<
          BookingRepository,
          BookingRepository,
          BookingRepository
        >
    with $Provider<BookingRepository> {
  BookingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookingRepository create(Ref ref) {
    return bookingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingRepository>(value),
    );
  }
}

String _$bookingRepositoryHash() => r'dbcf491d2f816d17ed94a598a26497c184881b0e';

@ProviderFor(BookingsNotifier)
final bookingsProvider = BookingsNotifierProvider._();

final class BookingsNotifierProvider
    extends $AsyncNotifierProvider<BookingsNotifier, List<BookingModel>> {
  BookingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingsNotifierHash();

  @$internal
  @override
  BookingsNotifier create() => BookingsNotifier();
}

String _$bookingsNotifierHash() => r'5d6f13d06f2dfbaa7af7d17eebf8414428f9992c';

abstract class _$BookingsNotifier extends $AsyncNotifier<List<BookingModel>> {
  FutureOr<List<BookingModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BookingModel>>, List<BookingModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BookingModel>>, List<BookingModel>>,
              AsyncValue<List<BookingModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(BookingDetailNotifier)
final bookingDetailProvider = BookingDetailNotifierFamily._();

final class BookingDetailNotifierProvider
    extends $AsyncNotifierProvider<BookingDetailNotifier, BookingModel> {
  BookingDetailNotifierProvider._({
    required BookingDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookingDetailNotifierHash();

  @override
  String toString() {
    return r'bookingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BookingDetailNotifier create() => BookingDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is BookingDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookingDetailNotifierHash() =>
    r'a08520c2decdb980f2c3f2b620f08cfd1ca94c4e';

final class BookingDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          BookingDetailNotifier,
          AsyncValue<BookingModel>,
          BookingModel,
          FutureOr<BookingModel>,
          String
        > {
  BookingDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'bookingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookingDetailNotifierProvider call(String id) =>
      BookingDetailNotifierProvider._(argument: id, from: this);

  @override
  String toString() => r'bookingDetailProvider';
}

abstract class _$BookingDetailNotifier extends $AsyncNotifier<BookingModel> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<BookingModel> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BookingModel>, BookingModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BookingModel>, BookingModel>,
              AsyncValue<BookingModel>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(CreateBookingNotifier)
final createBookingProvider = CreateBookingNotifierProvider._();

final class CreateBookingNotifierProvider
    extends $NotifierProvider<CreateBookingNotifier, bool> {
  CreateBookingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createBookingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createBookingNotifierHash();

  @$internal
  @override
  CreateBookingNotifier create() => CreateBookingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$createBookingNotifierHash() =>
    r'2ec43ed61bb8f5ec9cfcf3b07e07431cdbc36922';

abstract class _$CreateBookingNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PayBookingNotifier)
final payBookingProvider = PayBookingNotifierProvider._();

final class PayBookingNotifierProvider
    extends $NotifierProvider<PayBookingNotifier, bool> {
  PayBookingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payBookingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payBookingNotifierHash();

  @$internal
  @override
  PayBookingNotifier create() => PayBookingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$payBookingNotifierHash() =>
    r'61f679cb892f3a7651ec08d715841a28dde6eb69';

abstract class _$PayBookingNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
