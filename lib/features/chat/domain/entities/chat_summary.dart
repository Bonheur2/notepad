class ChatSummary {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageAt;
  final String lastMessageSenderId;

  const ChatSummary({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.lastMessageSenderId,
  });

  String otherParticipant(String myUid) =>
      participants.firstWhere((p) => p != myUid, orElse: () => myUid);
}
