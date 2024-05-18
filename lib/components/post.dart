import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

import '../models/post.dart';

class APost extends ConsumerStatefulWidget {
  const APost({super.key});

  @override
  ConsumerState<APost> createState() => _APostState();
}

class _APostState extends ConsumerState<APost> {
  @override
  Widget build(BuildContext context) {
    final copypastaAsync = ref.watch(copypastaProvider);
    return Container(
      child: copypastaAsync.when(
        data: (Post post) => Column(
          children: <Widget>[
            Text('Post ID: ${post.postId}'),
            Text('Author: ${post.author}'),
            Text('Timestamp: ${post.timestamp}'),
            Text('Title: ${post.title}'),
            SelectableText('Content: ${post.content}'),
            Text('Category: ${post.category}'),
            Text('Likes: ${post.likeCount}'),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
