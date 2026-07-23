import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/chat/data/repositories/chat_repository.dart';
import '../../features/chat/domain/entities/chat_message.dart';
import '../../features/chat/domain/entities/chat_summary.dart';
import 'core_providers.dart';

final chatRepositoryProvider = Provider<ChatRepository?>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null || user.isAnonymous) return null;
  return ChatRepository(user.uid);
});

final chatListProvider = StreamProvider<List<ChatSummary>>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchChats();
});

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((ref, chatId) {
  final repo = ref.watch(chatRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchMessages(chatId);
});
