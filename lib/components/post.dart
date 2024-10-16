import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';

import '../models/post.dart';

class APost extends ConsumerStatefulWidget {
  const APost({super.key});

  @override
  ConsumerState<APost> createState() => _APostState();
}

class _APostState extends ConsumerState<APost> {
  String _copyButtonText = 'Copy';
  Set<String> selected = {''};
  void updateVoting(Set<String> newSelection) {
    setState(() {
      selected = newSelection;
    });
    if (selected.isEmpty) {
      print('No vote');
    } else {
      print(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final copypastaAsync = ref.watch(copypastaProvider);
    return SizedBox(
      width: double.infinity,
      child: copypastaAsync.when(
        data: (Post post) => GestureDetector(
          onTap: () {
            print('Post ID: ${post.postId} clicked');
            context.push('/post/${post.postId}', extra: post);
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.author),
                                Text(post.timestamp),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          PopupMenuButton(
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share_rounded),
                                    SizedBox(width: 8),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          post.title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: Text(
                          post.content,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SegmentedButton(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: '+1',
                            label: Text('0'),
                            icon: Icon(Icons.keyboard_double_arrow_up_rounded),
                          ),
                          ButtonSegment<String>(
                            value: '-1',
                            label: Text('0'),
                            icon: Icon(Icons.keyboard_double_arrow_down_rounded),
                          ),
                        ],
                        selected: selected,
                        onSelectionChanged: updateVoting,
                        showSelectedIcon: false,
                        emptySelectionAllowed: true,
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: post.content));
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  content: Text(
                                    'Copied to clipboard',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                              setState(() {
                                _copyButtonText = 'Copied';
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            label: Text(_copyButtonText),
                            icon: const Icon(Icons.copy_rounded),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            label: const Text('Bookmark'),
                            icon: const Icon(Icons.bookmark_border_rounded),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
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
