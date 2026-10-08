// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(quotesRepository)
final quotesRepositoryProvider = QuotesRepositoryProvider._();

final class QuotesRepositoryProvider
    extends
        $FunctionalProvider<
          QuotesRepository,
          QuotesRepository,
          QuotesRepository
        >
    with $Provider<QuotesRepository> {
  QuotesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quotesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quotesRepositoryHash();

  @$internal
  @override
  $ProviderElement<QuotesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QuotesRepository create(Ref ref) {
    return quotesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuotesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuotesRepository>(value),
    );
  }
}

String _$quotesRepositoryHash() => r'f81fa7b3e7e6d54e0470ddd45735dfc2c44d4fb5';

@ProviderFor(quoteRequests)
final quoteRequestsProvider = QuoteRequestsProvider._();

final class QuoteRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QuoteRequestModel>>,
          List<QuoteRequestModel>,
          FutureOr<List<QuoteRequestModel>>
        >
    with
        $FutureModifier<List<QuoteRequestModel>>,
        $FutureProvider<List<QuoteRequestModel>> {
  QuoteRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quoteRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quoteRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<QuoteRequestModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<QuoteRequestModel>> create(Ref ref) {
    return quoteRequests(ref);
  }
}

String _$quoteRequestsHash() => r'8e98fb54e21a311662159d585d950ee965aa2133';

@ProviderFor(quoteRequestDetail)
final quoteRequestDetailProvider = QuoteRequestDetailFamily._();

final class QuoteRequestDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<QuoteRequestModel>,
          QuoteRequestModel,
          FutureOr<QuoteRequestModel>
        >
    with
        $FutureModifier<QuoteRequestModel>,
        $FutureProvider<QuoteRequestModel> {
  QuoteRequestDetailProvider._({
    required QuoteRequestDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'quoteRequestDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$quoteRequestDetailHash();

  @override
  String toString() {
    return r'quoteRequestDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<QuoteRequestModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<QuoteRequestModel> create(Ref ref) {
    final argument = this.argument as String;
    return quoteRequestDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteRequestDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$quoteRequestDetailHash() =>
    r'f96a796468a2e1acfd3b1092a173acdaeee04b96';

final class QuoteRequestDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<QuoteRequestModel>, String> {
  QuoteRequestDetailFamily._()
    : super(
        retry: null,
        name: r'quoteRequestDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  QuoteRequestDetailProvider call(String id) =>
      QuoteRequestDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'quoteRequestDetailProvider';
}
