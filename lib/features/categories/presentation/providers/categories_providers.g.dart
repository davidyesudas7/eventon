// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoriesRepository)
final categoriesRepositoryProvider = CategoriesRepositoryProvider._();

final class CategoriesRepositoryProvider
    extends
        $FunctionalProvider<
          CategoriesRepository,
          CategoriesRepository,
          CategoriesRepository
        >
    with $Provider<CategoriesRepository> {
  CategoriesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoriesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoriesRepository create(Ref ref) {
    return categoriesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoriesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoriesRepository>(value),
    );
  }
}

String _$categoriesRepositoryHash() =>
    r'742f4be7c33566a4bfb74c43fe0f482f05bcdc81';

@ProviderFor(getCategoriesUseCase)
final getCategoriesUseCaseProvider = GetCategoriesUseCaseProvider._();

final class GetCategoriesUseCaseProvider
    extends
        $FunctionalProvider<
          GetCategoriesUseCase,
          GetCategoriesUseCase,
          GetCategoriesUseCase
        >
    with $Provider<GetCategoriesUseCase> {
  GetCategoriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCategoriesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCategoriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCategoriesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCategoriesUseCase create(Ref ref) {
    return getCategoriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCategoriesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCategoriesUseCase>(value),
    );
  }
}

String _$getCategoriesUseCaseHash() =>
    r'ef482936a902997d7c780cc8d61500c06d8d5fe5';

@ProviderFor(getOccasionsUseCase)
final getOccasionsUseCaseProvider = GetOccasionsUseCaseProvider._();

final class GetOccasionsUseCaseProvider
    extends
        $FunctionalProvider<
          GetOccasionsUseCase,
          GetOccasionsUseCase,
          GetOccasionsUseCase
        >
    with $Provider<GetOccasionsUseCase> {
  GetOccasionsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOccasionsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOccasionsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetOccasionsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetOccasionsUseCase create(Ref ref) {
    return getOccasionsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetOccasionsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetOccasionsUseCase>(value),
    );
  }
}

String _$getOccasionsUseCaseHash() =>
    r'b2a5ed4a55254e08d3f67b2b3e3a50c132f54896';

@ProviderFor(getOccasionDetailUseCase)
final getOccasionDetailUseCaseProvider = GetOccasionDetailUseCaseProvider._();

final class GetOccasionDetailUseCaseProvider
    extends
        $FunctionalProvider<
          GetOccasionDetailUseCase,
          GetOccasionDetailUseCase,
          GetOccasionDetailUseCase
        >
    with $Provider<GetOccasionDetailUseCase> {
  GetOccasionDetailUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOccasionDetailUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOccasionDetailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetOccasionDetailUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetOccasionDetailUseCase create(Ref ref) {
    return getOccasionDetailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetOccasionDetailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetOccasionDetailUseCase>(value),
    );
  }
}

String _$getOccasionDetailUseCaseHash() =>
    r'60f667e672acab1cb6e0f073f9cdb35e2bca774f';

@ProviderFor(occasions)
final occasionsProvider = OccasionsProvider._();

final class OccasionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Occasion>>,
          List<Occasion>,
          FutureOr<List<Occasion>>
        >
    with $FutureModifier<List<Occasion>>, $FutureProvider<List<Occasion>> {
  OccasionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'occasionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$occasionsHash();

  @$internal
  @override
  $FutureProviderElement<List<Occasion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Occasion>> create(Ref ref) {
    return occasions(ref);
  }
}

String _$occasionsHash() => r'4c1ddd0a91810a2e5e91276d2d2c2e0b43f409bc';

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'ee8a08918a2e739d2325113b1a26854071ab575a';

@ProviderFor(occasionDetail)
final occasionDetailProvider = OccasionDetailFamily._();

final class OccasionDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<OccasionDetail>,
          OccasionDetail,
          FutureOr<OccasionDetail>
        >
    with $FutureModifier<OccasionDetail>, $FutureProvider<OccasionDetail> {
  OccasionDetailProvider._({
    required OccasionDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'occasionDetailProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$occasionDetailHash();

  @override
  String toString() {
    return r'occasionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OccasionDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OccasionDetail> create(Ref ref) {
    final argument = this.argument as String;
    return occasionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OccasionDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$occasionDetailHash() => r'36fbef28d9c2534c709a38b29e9135827aa58d70';

final class OccasionDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OccasionDetail>, String> {
  OccasionDetailFamily._()
    : super(
        retry: null,
        name: r'occasionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  OccasionDetailProvider call(String slug) =>
      OccasionDetailProvider._(argument: slug, from: this);

  @override
  String toString() => r'occasionDetailProvider';
}
