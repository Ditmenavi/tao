import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostContent extends ConsumerStatefulWidget {
  final String id;
  const PostContent({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostContentState();
}

class _PostContentState extends ConsumerState<PostContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: () => context.pop(), child: Text('Post ${widget.id}')),
      ),
    );
  }
}
