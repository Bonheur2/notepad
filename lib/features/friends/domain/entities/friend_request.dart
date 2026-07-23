class FriendRequest {
  final String id;
  final String fromUid;
  final String toUid;
  final String fromEmail;
  final String fromDisplayName;
  final String status;
  final DateTime createdAt;

  const FriendRequest({
    required this.id,
    required this.fromUid,
    required this.toUid,
    required this.fromEmail,
    required this.fromDisplayName,
    required this.status,
    required this.createdAt,
  });
}
