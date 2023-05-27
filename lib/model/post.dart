class Post {
  String id;
  String userID;
  String body;
  num? rating;
  List<String>? imageUrls;
  List<String>? comments;

  Post({
    required this.id,
    required this.userID,
    required this.body,
    this.rating = 0,
    required this.imageUrls,
    this.comments,
  });
}
