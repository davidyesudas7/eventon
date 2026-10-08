// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExploreLocation)
final exploreLocationProvider = ExploreLocationProvider._();

final class ExploreLocationProvider
    extends $NotifierProvider<ExploreLocation, SavedLocation?> {
  ExploreLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exploreLocationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exploreLocationHash();

  @$internal
  @override
  ExploreLocation create() => ExploreLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavedLocation? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavedLocation?>(value),
    );
  }
}

String _$exploreLocationHash() => r'3432911aa7d7772e3a15b06b8e09816b864214e7';

abstract class _$ExploreLocation extends $Notifier<SavedLocation?> {
  SavedLocation? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SavedLocation?, SavedLocation?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SavedLocation?, SavedLocation?>,
              SavedLocation?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(LocationSearchController)
final locationSearchControllerProvider = LocationSearchControllerProvider._();

final class LocationSearchControllerProvider
    extends $NotifierProvider<LocationSearchController, LocationSearchState> {
  LocationSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationSearchControllerHash();

  @$internal
  @override
  LocationSearchController create() => LocationSearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationSearchState>(value),
    );
  }
}

String _$locationSearchControllerHash() =>
    r'9c65a1de79214dd87256b25715f5f5395b709926';

abstract class _$LocationSearchController
    extends $Notifier<LocationSearchState> {
  LocationSearchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LocationSearchState, LocationSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocationSearchState, LocationSearchState>,
              LocationSearchState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
