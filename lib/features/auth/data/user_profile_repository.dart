import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/user_profile.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  Future<void> upsertProfile(UserProfile profile) {
    return _usersRef.doc(profile.uid).set({
      'email': profile.email,
      'displayName': profile.displayName,
      'createdAt': profile.createdAt.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<void> ensureProfile({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final existing = await getProfile(uid);
    if (existing == null) {
      await upsertProfile(UserProfile(
        uid: uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      ));
    } else {
      // Merge without touching createdAt, so re-checks on later visits don't
      // overwrite the original creation time.
      await _usersRef.doc(uid).set({
        'email': email,
        'displayName': displayName,
      }, SetOptions(merge: true));
    }
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return _fromDoc(doc.id, doc.data()!);
  }

  Future<UserProfile?> findByEmail(String email) async {
    final query = await _usersRef.where('email', isEqualTo: email).limit(1).get();
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    return _fromDoc(doc.id, doc.data());
  }

  UserProfile _fromDoc(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
