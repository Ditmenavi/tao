import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:wagashi/models/post.dart';

class PostContent extends ConsumerStatefulWidget {
  final Post post;
  const PostContent({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostContentState();
}

class _PostContentState extends ConsumerState<PostContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.post.postId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Post ID: ${widget.post.postId}'),
            Text('Post Title: ${widget.post.title}'),
            Text('Post Content: ${widget.post.content}'),
          ],
        ),
      ),
    );
  }
}
