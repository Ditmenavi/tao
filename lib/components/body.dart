import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../providers/providers.dart';

class MyBody extends ConsumerStatefulWidget {
  const MyBody({super.key});

  @override
  ConsumerState<MyBody> createState() => _MyBodyState();
}

class _MyBodyState extends ConsumerState<MyBody> {
  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider); // Access counter state directly
    final copypastaAsync = ref.watch(copypastaProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Hello, World!'),
          Text('Clicked $counter times!'),
          copypastaAsync.when(
            data: (Post post) => Column(
              children: <Widget>[
                Text('Post ID: ${post.postId}'),
                Text('Author: ${post.author}'),
                Text('Timestamp: ${post.timestamp}'),
                Text('Title: ${post.title}'),
                Text('Content: ${post.content}'),
                Text('Category: ${post.category}'),
                Text('Likes: ${post.likeCount}'),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}
