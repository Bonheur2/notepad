import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;

    final credential = await _auth.signInAnonymously();
    return credential.user!.uid;
  }

  Stream<User?> authStateChanges() => _auth.userChanges();

  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;

  Future<User> linkWithEmail(String email, String password) async {
    final credential = EmailAuthProvider.credential(email: email, password: password);
    final result = await _auth.currentUser!.linkWithCredential(credential);
    return result.user!;
  }

  Future<User> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user!;
  }

  Future<void> signOut() => _auth.signOut();
}
