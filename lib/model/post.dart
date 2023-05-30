class Post {
  String id;
  String userId;
  String body;
  num? rating;
  String? imageUrl;
  List<String>? comments;
  String category;

  Post(
      {required this.id,
      required this.userId,
      required this.body,
      this.rating = 0,
      required this.imageUrl,
      this.comments,
      required this.category});
}
