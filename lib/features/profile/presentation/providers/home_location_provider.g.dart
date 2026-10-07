// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeLocationState)
final homeLocationStateProvider = HomeLocationStateProvider._();

final class HomeLocationStateProvider
    extends $AsyncNotifierProvider<HomeLocationState, HomeLocation?> {
  HomeLocationStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLocationStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLocationStateHash();

  @$internal
  @override
  HomeLocationState create() => HomeLocationState();
}

String _$homeLocationStateHash() => r'846ca9c732911bf7231a9c2c8d7b682ab199de4b';

abstract class _$HomeLocationState extends $AsyncNotifier<HomeLocation?> {
  FutureOr<HomeLocation?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HomeLocation?>, HomeLocation?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HomeLocation?>, HomeLocation?>,
              AsyncValue<HomeLocation?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(fetchPincode)
final fetchPincodeProvider = FetchPincodeFamily._();

final class FetchPincodeProvider
    extends
        $FunctionalProvider<
          AsyncValue<PincodeDetails?>,
          PincodeDetails?,
          FutureOr<PincodeDetails?>
        >
    with $FutureModifier<PincodeDetails?>, $FutureProvider<PincodeDetails?> {
  FetchPincodeProvider._({
    required FetchPincodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchPincodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchPincodeHash();

  @override
  String toString() {
    return r'fetchPincodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PincodeDetails?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PincodeDetails?> create(Ref ref) {
    final argument = this.argument as String;
    return fetchPincode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPincodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchPincodeHash() => r'4cc729f9acf3860b510dfede393b4b47dbf9788f';

final class FetchPincodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PincodeDetails?>, String> {
  FetchPincodeFamily._()
    : super(
        retry: null,
        name: r'fetchPincodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchPincodeProvider call(String pincode) =>
      FetchPincodeProvider._(argument: pincode, from: this);

  @override
  String toString() => r'fetchPincodeProvider';
}

@ProviderFor(searchLsg)
final searchLsgProvider = SearchLsgFamily._();

final class SearchLsgProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LsgDetails>>,
          List<LsgDetails>,
          FutureOr<List<LsgDetails>>
        >
    with $FutureModifier<List<LsgDetails>>, $FutureProvider<List<LsgDetails>> {
  SearchLsgProvider._({
    required SearchLsgFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchLsgProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchLsgHash();

  @override
  String toString() {
    return r'searchLsgProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LsgDetails>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LsgDetails>> create(Ref ref) {
    final argument = this.argument as String;
    return searchLsg(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchLsgProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchLsgHash() => r'0494af1a28e2b45bcd35afa1920a1a6fb870a634';

final class SearchLsgFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LsgDetails>>, String> {
  SearchLsgFamily._()
    : super(
        retry: null,
        name: r'searchLsgProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchLsgProvider call(String query) =>
      SearchLsgProvider._(argument: query, from: this);

  @override
  String toString() => r'searchLsgProvider';
}
