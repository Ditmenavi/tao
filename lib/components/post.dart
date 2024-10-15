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
    return SizedBox(
      width: double.infinity,
      child: copypastaAsync.when(
        data: (Post post) => Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(post.author),
                        ),
                      ],
                    ),
                    Text(post.timestamp),
                  ],
                ),
              ),
              Text(post.content),
            ],
          ),
        ),
        loading: () => const Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }
}
