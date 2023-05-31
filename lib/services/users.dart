import 'package:cleotour/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final COLLECTION_NAME = 'users';

  Future<DocumentSnapshot> fetchUser(String uid) async {
    DocumentSnapshot user =
        await _firestore.collection(COLLECTION_NAME).doc(uid).get();
    return user;
  }

  User? getCurrentUser() {
    return Auth().getCurrentUser();
  }

  void signOut() {
    Auth().signOut();
  }
}
