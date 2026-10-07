// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuoteCart)
final quoteCartProvider = QuoteCartProvider._();

final class QuoteCartProvider
    extends $NotifierProvider<QuoteCart, List<QuoteItem>> {
  QuoteCartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quoteCartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quoteCartHash();

  @$internal
  @override
  QuoteCart create() => QuoteCart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<QuoteItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<QuoteItem>>(value),
    );
  }
}

String _$quoteCartHash() => r'2ef92806db08c5fc6ba04dbde8cf76f88ac9d063';

abstract class _$QuoteCart extends $Notifier<List<QuoteItem>> {
  List<QuoteItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<QuoteItem>, List<QuoteItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<QuoteItem>, List<QuoteItem>>,
              List<QuoteItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
