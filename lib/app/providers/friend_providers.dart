import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/friends/data/repositories/friend_repository.dart';
import '../../features/friends/domain/entities/friend.dart';
import '../../features/friends/domain/entities/friend_request.dart';
import 'core_providers.dart';

final friendRepositoryProvider = Provider<FriendRepository?>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null || user.isAnonymous) return null;
  return FriendRepository(user.uid);
});

final incomingFriendRequestsProvider = StreamProvider<List<FriendRequest>>((ref) {
  final repo = ref.watch(friendRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchIncoming();
});

final outgoingFriendRequestsProvider = StreamProvider<List<FriendRequest>>((ref) {
  final repo = ref.watch(friendRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchOutgoing();
});

final friendsProvider = StreamProvider<List<Friend>>((ref) {
  final repo = ref.watch(friendRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchFriends();
});
