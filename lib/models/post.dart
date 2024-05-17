class Post {
  int postId;
  String author;
  DateTime timestamp;
  String title;
  String content;
  String category;
  int likeCount;

  Post({
    required this.postId,
    required this.author,
    required this.timestamp,
    required this.title,
    required this.content,
    required this.category,
    required this.likeCount,
  });
}
