import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/chat_providers.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/providers/friend_providers.dart';
import '../../../../app/widgets/empty_state.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../../friends/data/repositories/friend_repository.dart';
import '../../../friends/domain/entities/friend.dart';
import '../../../friends/domain/entities/friend_request.dart';
import '../../data/repositories/chat_repository.dart';

class ChatHomeScreen extends ConsumerStatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  ConsumerState<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends ConsumerState<ChatHomeScreen> {
  Future<void> _showAddFriendDialog(String myUid) async {
    final controller = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add friend'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Friend\'s email'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Send request'),
          ),
        ],
      ),
    );

    if (email == null || email.isEmpty || !mounted) return;
    final normalizedEmail = email.toLowerCase();

    final friendRepo = ref.read(friendRepositoryProvider);
    if (friendRepo == null) return;

    final found = await friendRepo.findUserByEmail(normalizedEmail);
    if (!mounted) return;

    if (found == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No account found for $email')),
      );
      return;
    }

    if (found.uid == myUid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That\'s your own account')),
      );
      return;
    }

    final myProfile = await ref.read(userProfileRepositoryProvider).getProfile(myUid);
    await friendRepo.sendRequest(
      toUid: found.uid,
      fromEmail: myProfile?.email ?? '',
      fromDisplayName: myProfile?.displayName ?? '',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent to ${found.displayName}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final isAnonymous = user?.isAnonymous ?? true;

    if (isAnonymous) {
      final colorScheme = Theme.of(context).colorScheme;
      return Scaffold(
        appBar: AppBar(title: const Text('Friends & Chats')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group_add_outlined, size: 40, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Create an account to add friends and chat',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.push('/account'),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final myUid = user!.uid;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends & Chats'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_alt),
              tooltip: 'Add friend',
              onPressed: () => _showAddFriendDialog(myUid),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Friends'),
              Tab(text: 'Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ChatsTab(myUid: myUid),
            _FriendsTab(myUid: myUid),
            const _RequestsTab(),
          ],
        ),
      ),
    );
  }
}

String _relativeTime(DateTime dt) {
  final local = dt.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(local.year, local.month, local.day);
  final diff = today.difference(date).inDays;
  if (diff == 0) {
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  if (diff == 1) return 'Yesterday';
  if (diff < 7) return '${diff}d ago';
  return '${local.day}/${local.month}/${local.year}';
}

class _ChatsTab extends ConsumerWidget {
  final String myUid;

  const _ChatsTab({required this.myUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatsAsync = ref.watch(chatListProvider);
    final friendsAsync = ref.watch(friendsProvider);
    final friendsByUid = {
      for (final f in friendsAsync.valueOrNull ?? <Friend>[]) f.uid: f,
    };

    return chatsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (chats) {
        if (chats.isEmpty) {
          return const EmptyState(
            icon: Icons.chat_bubble_outline,
            message: 'No conversations yet.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          itemCount: chats.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final chat = chats[index];
            final otherUid = chat.otherParticipant(myUid);
            final friend = friendsByUid[otherUid];
            final name = friend?.displayName ?? 'Unknown';
            return Card(
              child: ListTile(
                leading: const _PersonAvatar(),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _relativeTime(chat.lastMessageAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                onTap: () => context.push('/chat/${chat.chatId}', extra: name),
              ),
            );
          },
        );
      },
    );
  }
}

class _PersonAvatar extends StatelessWidget {
  const _PersonAvatar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CircleAvatar(
      backgroundColor: colorScheme.primaryContainer,
      child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
    );
  }
}

class _FriendsTab extends ConsumerWidget {
  final String myUid;

  const _FriendsTab({required this.myUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return friendsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (friends) {
        if (friends.isEmpty) {
          return const EmptyState(
            icon: Icons.people_outline,
            message: 'No friends yet. Add one by email.',
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          itemCount: friends.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Card(
              child: ListTile(
                leading: const _PersonAvatar(),
                title: Text(friend.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(friend.email),
                trailing: IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  tooltip: 'Message ${friend.displayName}',
                  onPressed: () {
                    final chatId = ChatRepository.computeChatId(myUid, friend.uid);
                    context.push('/chat/$chatId', extra: friend.displayName);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingAsync = ref.watch(incomingFriendRequestsProvider);
    final outgoingAsync = ref.watch(outgoingFriendRequestsProvider);
    final friendRepo = ref.watch(friendRepositoryProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final sectionStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurfaceVariant,
          letterSpacing: 0.3,
        );
    final emptyStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: colorScheme.onSurfaceVariant);

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text('INCOMING', style: sectionStyle),
        ),
        incomingAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $err'),
          ),
          data: (requests) {
            if (requests.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text('No pending requests.', style: emptyStyle),
              );
            }
            return Column(
              children: requests
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: _IncomingRequestTile(request: r, friendRepo: friendRepo),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
          child: Text('SENT', style: sectionStyle),
        ),
        outgoingAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $err'),
          ),
          data: (requests) {
            if (requests.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Text('No sent requests.', style: emptyStyle),
              );
            }
            return Column(
              children: requests
                  .map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(child: _OutgoingRequestTile(request: r)),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _IncomingRequestTile extends StatelessWidget {
  final FriendRequest request;
  final FriendRepository? friendRepo;

  const _IncomingRequestTile({required this.request, required this.friendRepo});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: const _PersonAvatar(),
      title: Text(request.fromDisplayName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(request.fromEmail),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filled(
            icon: const Icon(Icons.check, size: 18),
            tooltip: 'Accept request',
            onPressed: friendRepo == null ? null : () => friendRepo!.acceptRequest(request),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.error),
            tooltip: 'Decline request',
            onPressed: friendRepo == null ? null : () => friendRepo!.declineRequest(request.id),
          ),
        ],
      ),
    );
  }
}

class _OutgoingRequestTile extends ConsumerWidget {
  final FriendRequest request;

  const _OutgoingRequestTile({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<UserProfile?>(
      future: ref.read(userProfileRepositoryProvider).getProfile(request.toUid),
      builder: (context, snapshot) {
        final name = snapshot.data?.displayName;
        return ListTile(
          leading: const _PersonAvatar(),
          title: Text(name ?? 'Loading…', style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: Chip(
            label: const Text('Pending'),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      },
    );
  }
}
