import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_summary.dart';

class ChatRepository {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRepository(this.uid);

  static String computeChatId(String uidA, String uidB) {
    final sorted = [uidA, uidB]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  CollectionReference<Map<String, dynamic>> get _chatsRef =>
      _firestore.collection('chats');

  Stream<List<ChatSummary>> watchChats() {
    return _chatsRef
        .where('participants', arrayContains: uid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return ChatSummary(
                chatId: doc.id,
                participants: List<String>.from(data['participants'] ?? []),
                lastMessage: data['lastMessage'] ?? '',
                lastMessageAt: DateTime.parse(data['lastMessageAt']),
                lastMessageSenderId: data['lastMessageSenderId'] ?? '',
              );
            }).toList());
  }

  Stream<List<ChatMessage>> watchMessages(String chatId) {
    // The `where` clause here isn't just an optimization: Firestore rejects
    // a `list` query outright unless the query itself can prove (from its
    // shape) that every possible result satisfies the security rule. The
    // rule checks `resource.data.participants`, so the query needs a
    // matching `arrayContains` filter or Firestore denies the whole listen,
    // even though every actual document would individually pass the rule.
    return _chatsRef
        .doc(chatId)
        .collection('messages')
        .where('participants', arrayContains: uid)
        .orderBy('sentAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return ChatMessage(
                id: doc.id,
                senderId: data['senderId'] ?? '',
                text: data['text'] ?? '',
                sentAt: DateTime.parse(data['sentAt']),
              );
            }).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required List<String> participants,
    required String text,
  }) async {
    final now = DateTime.now().toIso8601String();
    final batch = _firestore.batch();

    final messageRef = _chatsRef.doc(chatId).collection('messages').doc();
    batch.set(messageRef, {
      'senderId': uid,
      'text': text,
      'sentAt': now,
      'participants': participants,
    });

    batch.set(
      _chatsRef.doc(chatId),
      {
        'participants': participants,
        'lastMessage': text,
        'lastMessageAt': now,
        'lastMessageSenderId': uid,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }
}
