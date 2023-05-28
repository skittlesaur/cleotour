class Comment {
  String? userID;
  String? postID;
  String? id;
  String? content;
  num? likes;

  Comment({
    required this.id,
    required this.userID,
    required this.postID,
    this.likes = 0,
    required this.content,
  });
}
