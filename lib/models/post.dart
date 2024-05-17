class Post {
  String author;
  DateTime timestamp;
  String title;
  String content;
  int likeCount;

  Post({
    required this.author,
    required this.timestamp,
    required this.title,
    required this.content,
    required this.likeCount,
  });
}
