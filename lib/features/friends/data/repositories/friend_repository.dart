import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/user_profile_repository.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/entities/friend.dart';
import '../../domain/entities/friend_request.dart';

class FriendRepository {
  final String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserProfileRepository _profileRepo = UserProfileRepository();

  FriendRepository(this.uid);

  CollectionReference<Map<String, dynamic>> get _requestsRef =>
      _firestore.collection('friendRequests');

  CollectionReference<Map<String, dynamic>> get _friendsRef =>
      _firestore.collection('users').doc(uid).collection('friends');

  Future<UserProfile?> findUserByEmail(String email) {
    return _profileRepo.findByEmail(email);
  }

  Future<void> sendRequest({
    required String toUid,
    required String fromEmail,
    required String fromDisplayName,
  }) {
    return _requestsRef.add({
      'fromUid': uid,
      'toUid': toUid,
      'fromEmail': fromEmail,
      'fromDisplayName': fromDisplayName,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<FriendRequest>> watchIncoming() {
    return _requestsRef
        .where('toUid', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _fromDoc(doc)).toList());
  }

  Stream<List<FriendRequest>> watchOutgoing() {
    return _requestsRef
        .where('fromUid', isEqualTo: uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => _fromDoc(doc)).toList());
  }

  Future<void> acceptRequest(FriendRequest request) async {
    final myProfile = await _profileRepo.getProfile(uid);
    final batch = _firestore.batch();
    final now = DateTime.now().toIso8601String();

    batch.set(
      _firestore.collection('users').doc(request.toUid).collection('friends').doc(request.fromUid),
      {
        'displayName': request.fromDisplayName,
        'email': request.fromEmail,
        'since': now,
      },
    );
    batch.set(
      _firestore.collection('users').doc(request.fromUid).collection('friends').doc(request.toUid),
      {
        'displayName': myProfile?.displayName ?? '',
        'email': myProfile?.email ?? '',
        'since': now,
      },
    );
    batch.update(_requestsRef.doc(request.id), {'status': 'accepted'});

    await batch.commit();
  }

  Future<void> declineRequest(String requestId) {
    return _requestsRef.doc(requestId).update({'status': 'declined'});
  }

  Stream<List<Friend>> watchFriends() {
    return _friendsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Friend(
          uid: doc.id,
          displayName: data['displayName'] ?? '',
          email: data['email'] ?? '',
          since: DateTime.parse(data['since']),
        );
      }).toList();
    });
  }

  FriendRequest _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return FriendRequest(
      id: doc.id,
      fromUid: data['fromUid'],
      toUid: data['toUid'],
      fromEmail: data['fromEmail'] ?? '',
      fromDisplayName: data['fromDisplayName'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
