import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/chat_providers.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/providers/friend_providers.dart';
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

    final friendRepo = ref.read(friendRepositoryProvider);
    if (friendRepo == null) return;

    final found = await friendRepo.findUserByEmail(email);
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
      return Scaffold(
        appBar: AppBar(title: const Text('Friends & Chats')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create an account to add friends and chat',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
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
          return const Center(child: Text('No conversations yet.'));
        }
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            final otherUid = chat.otherParticipant(myUid);
            final friend = friendsByUid[otherUid];
            final name = friend?.displayName ?? 'Unknown';
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(name),
              subtitle: Text(
                chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => context.push('/chat/${chat.chatId}', extra: name),
            );
          },
        );
      },
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
          return const Center(child: Text('No friends yet. Add one by email.'));
        }
        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(friend.displayName),
              subtitle: Text(friend.email),
              trailing: IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                tooltip: 'Message ${friend.displayName}',
                onPressed: () {
                  final chatId = ChatRepository.computeChatId(myUid, friend.uid);
                  context.push('/chat/$chatId', extra: friend.displayName);
                },
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

    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text('Incoming', style: TextStyle(fontWeight: FontWeight.bold)),
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
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('No pending requests.'),
              );
            }
            return Column(
              children: requests.map((r) => _IncomingRequestTile(request: r, friendRepo: friendRepo)).toList(),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text('Sent', style: TextStyle(fontWeight: FontWeight.bold)),
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
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('No sent requests.'),
              );
            }
            return Column(
              children: requests.map((r) => _OutgoingRequestTile(request: r)).toList(),
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
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(request.fromDisplayName),
      subtitle: Text(request.fromEmail),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Accept request',
            onPressed: friendRepo == null ? null : () => friendRepo!.acceptRequest(request),
          ),
          IconButton(
            icon: const Icon(Icons.close),
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
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(name ?? 'Loading…'),
          trailing: const Text('Pending'),
        );
      },
    );
  }
}
