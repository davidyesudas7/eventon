// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(placesApiClient)
final placesApiClientProvider = PlacesApiClientProvider._();

final class PlacesApiClientProvider
    extends
        $FunctionalProvider<PlacesApiClient, PlacesApiClient, PlacesApiClient>
    with $Provider<PlacesApiClient> {
  PlacesApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placesApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placesApiClientHash();

  @$internal
  @override
  $ProviderElement<PlacesApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlacesApiClient create(Ref ref) {
    return placesApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlacesApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlacesApiClient>(value),
    );
  }
}

String _$placesApiClientHash() => r'd686f2e8f8906ef334f439ebbf496e015f972522';
