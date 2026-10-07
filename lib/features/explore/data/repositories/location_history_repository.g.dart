// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationHistoryRepository)
final locationHistoryRepositoryProvider = LocationHistoryRepositoryProvider._();

final class LocationHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          LocationHistoryRepository,
          LocationHistoryRepository,
          LocationHistoryRepository
        >
    with $Provider<LocationHistoryRepository> {
  LocationHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationHistoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationHistoryRepository create(Ref ref) {
    return locationHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationHistoryRepository>(value),
    );
  }
}

String _$locationHistoryRepositoryHash() =>
    r'2e820be1c041ff4b0ce02f0856250aaabf0f4f27';
