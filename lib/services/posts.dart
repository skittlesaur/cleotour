import 'package:cloud_firestore/cloud_firestore.dart';

class PostsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final COLLECTION_NAME = 'Posts';
  final int FETCH_POSTS_LIMIT = 2;

  Future<QuerySnapshot> fetchPostsPaginated(
      String categoryValue, List<DocumentSnapshot> posts) async {
    Query query = _firestore
        .collection(COLLECTION_NAME)
        .orderBy('postedAt', descending: true);

    if (categoryValue != "All") {
      query = query.where('category', isEqualTo: categoryValue);
    }

    if (posts.isNotEmpty) {
      query = query.startAfterDocument(posts[posts.length - 1]);
    }

    return await query.limit(FETCH_POSTS_LIMIT).get();
  }

  Future<QuerySnapshot> fetchUserFavorites(List<dynamic> favs) async {
    Query query = _firestore
        .collection(COLLECTION_NAME)
        .where(FieldPath.documentId, whereIn: favs);
    return await query.get();
  }

  Future<QuerySnapshot> fetchUserPosts(String uid) async {
    Query query = _firestore
        .collection(COLLECTION_NAME)
        .where('posterId', isEqualTo: uid);
    return await query.get();
  }

  Stream<QuerySnapshot> fetchUserPostsStream(String uid) {
    return _firestore
        .collection(COLLECTION_NAME)
        .where('posterId', isEqualTo: uid)
        .snapshots();
  }

  Future deletePost(String postId) async {
    await _firestore.collection(COLLECTION_NAME).doc(postId).delete();
  }

  int get getFetchPostsLimit {
    return FETCH_POSTS_LIMIT;
  }
}
