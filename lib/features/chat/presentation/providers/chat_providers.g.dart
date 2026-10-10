// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(conversationDetail)
final conversationDetailProvider = ConversationDetailFamily._();

final class ConversationDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConversationModel>,
          ConversationModel,
          FutureOr<ConversationModel>
        >
    with
        $FutureModifier<ConversationModel>,
        $FutureProvider<ConversationModel> {
  ConversationDetailProvider._({
    required ConversationDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conversationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationDetailHash();

  @override
  String toString() {
    return r'conversationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ConversationModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConversationModel> create(Ref ref) {
    final argument = this.argument as String;
    return conversationDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationDetailHash() =>
    r'7a7fd4e7205826927a2a23471915dcfb199fd0fb';

final class ConversationDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ConversationModel>, String> {
  ConversationDetailFamily._()
    : super(
        retry: null,
        name: r'conversationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConversationDetailProvider call(String id) =>
      ConversationDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'conversationDetailProvider';
}

@ProviderFor(listingDetail)
final listingDetailProvider = ListingDetailFamily._();

final class ListingDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<ListingDetailModel>,
          ListingDetailModel,
          FutureOr<ListingDetailModel>
        >
    with
        $FutureModifier<ListingDetailModel>,
        $FutureProvider<ListingDetailModel> {
  ListingDetailProvider._({
    required ListingDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listingDetailHash();

  @override
  String toString() {
    return r'listingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ListingDetailModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ListingDetailModel> create(Ref ref) {
    final argument = this.argument as String;
    return listingDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ListingDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listingDetailHash() => r'83647372f2a44c52ad10c2d09bf7bdf6b6224482';

final class ListingDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ListingDetailModel>, String> {
  ListingDetailFamily._()
    : super(
        retry: null,
        name: r'listingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListingDetailProvider call(String id) =>
      ListingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'listingDetailProvider';
}

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'75e5f3047e50d606a0dc1fd0785cf55d082e5cb0';

@ProviderFor(ConversationsNotifier)
final conversationsProvider = ConversationsNotifierProvider._();

final class ConversationsNotifierProvider
    extends
        $AsyncNotifierProvider<ConversationsNotifier, List<ConversationModel>> {
  ConversationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsNotifierHash();

  @$internal
  @override
  ConversationsNotifier create() => ConversationsNotifier();
}

String _$conversationsNotifierHash() =>
    r'409d27a7d24ac3444b1a40e2c2d96338c09d0805';

abstract class _$ConversationsNotifier
    extends $AsyncNotifier<List<ConversationModel>> {
  FutureOr<List<ConversationModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ConversationModel>>,
              List<ConversationModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConversationModel>>,
                List<ConversationModel>
              >,
              AsyncValue<List<ConversationModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatDetailNotifier)
final chatDetailProvider = ChatDetailNotifierFamily._();

final class ChatDetailNotifierProvider
    extends $AsyncNotifierProvider<ChatDetailNotifier, List<MessageModel>> {
  ChatDetailNotifierProvider._({
    required ChatDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatDetailNotifierHash();

  @override
  String toString() {
    return r'chatDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatDetailNotifier create() => ChatDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is ChatDetailNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatDetailNotifierHash() =>
    r'daae7b9535f75bbfd63cc97a4cc25239af747dba';

final class ChatDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatDetailNotifier,
          AsyncValue<List<MessageModel>>,
          List<MessageModel>,
          FutureOr<List<MessageModel>>,
          String
        > {
  ChatDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'chatDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatDetailNotifierProvider call(String conversationId) =>
      ChatDetailNotifierProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatDetailProvider';
}

abstract class _$ChatDetailNotifier extends $AsyncNotifier<List<MessageModel>> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  FutureOr<List<MessageModel>> build(String conversationId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MessageModel>>, List<MessageModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MessageModel>>, List<MessageModel>>,
              AsyncValue<List<MessageModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(CreateConversationNotifier)
final createConversationProvider = CreateConversationNotifierProvider._();

final class CreateConversationNotifierProvider
    extends $NotifierProvider<CreateConversationNotifier, bool> {
  CreateConversationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createConversationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createConversationNotifierHash();

  @$internal
  @override
  CreateConversationNotifier create() => CreateConversationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$createConversationNotifierHash() =>
    r'e578dede0adc3211bc47469eb9c142a3ad4c3646';

abstract class _$CreateConversationNotifier extends $Notifier<bool> {
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
