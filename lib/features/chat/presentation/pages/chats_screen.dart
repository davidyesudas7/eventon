import 'package:eventon/core/widgets/eventon_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/conversation_model.dart';
import '../providers/chat_providers.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    if (authState is! AuthStateAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.surfaceWhite,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceWhite,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoutes.home);
              }
            },
          ),
          title: Text(
            'EventOn',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.borderSubtle, height: 1),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Sign in to view messages',
                  style: AppTextStyles.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log in to chat with vendors and manage your inquiries.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pushNamed(AppRoutes.signInMobile),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Log In'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final conversationsState = ref.watch(conversationsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.goNamed(AppRoutes.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceWhite,
        // appBar: EventOnAppBar(showBack: false),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Messages',
                      style: AppTextStyles.headlineMd.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoutes.quoteRequests);
                      },
                      child: Text(
                        'Quote requests',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: conversationsState.when(
                  data: (conversations) {
                    if (conversations.isEmpty) {
                      return const Center(child: Text('No messages yet'));
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(conversationsProvider);
                        await ref.read(conversationsProvider.future);
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: conversations.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 32,
                          color: AppColors.borderSubtle,
                        ),
                        itemBuilder: (context, index) {
                          final conversation = conversations[index];
                          return ChatItemWidget(conversation: conversation);
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatItemWidget extends ConsumerWidget {
  final ConversationModel conversation;

  const ChatItemWidget({super.key, required this.conversation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingState = ref.watch(
      listingDetailProvider(conversation.listingId),
    );

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.chatDetails,
          pathParameters: {'id': conversation.id},
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listingState.when(
                  data: (listing) => Text(
                    listing.title.isEmpty ? 'Unknown Listing' : listing.title,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: conversation.unreadCount > 0
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                  loading: () => Text(
                    'Loading...',
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  error: (_, _) => Text(
                    'Unknown',
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  conversation.lastMessagePreview ?? 'No messages yet',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: conversation.unreadCount > 0
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: conversation.unreadCount > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (conversation.lastMessageAt != null)
                Text(
                  _formatTime(conversation.lastMessageAt!),
                  style: AppTextStyles.labelSm.copyWith(
                    color: conversation.unreadCount > 0
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: conversation.unreadCount > 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              if (conversation.unreadCount > 0) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(minWidth: 20),
                  alignment: Alignment.center,
                  child: Text(
                    conversation.unreadCount > 99
                        ? '99+'
                        : '${conversation.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
