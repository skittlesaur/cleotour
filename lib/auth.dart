import 'package:cleotour/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  UserModel? getCurrentUser() {
    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      return UserModel(
        id: currentUser.uid,
        email: currentUser.email!,
        userName: currentUser.displayName!,
      );
    } else {
      return null;
    }
  }
}
