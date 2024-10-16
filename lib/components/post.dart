import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
  final String _copyButtonText = 'Copy';
  Set<String> selected = {''};

  @override
  Widget build(BuildContext context) {
    var votingAsync = ref.watch(votingProvider);
    final copypastaAsync = ref.watch(copypastaProvider);

    void updateVoting(Set<String> newSelection) {
      setState(() {
        selected = newSelection;
        ref.read(votingProvider.notifier).update((state) => newSelection);
      });
      //TODO: Implement voting logic
      if (selected.isEmpty) {
        print('No vote');
      } else {
        print(selected);
      }
    }

    return SizedBox(
      width: double.infinity,
      child: copypastaAsync.when(
        data: (Post post) => GestureDetector(
          onTap: () {
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                    Icon(Icons.share),
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
                            icon: Icon(Icons.keyboard_double_arrow_up),
                          ),
                          ButtonSegment<String>(
                            value: '-1',
                            label: Text('0'),
                            icon: Icon(Icons.keyboard_double_arrow_down),
                          ),
                        ],
                        selected: votingAsync,
                        onSelectionChanged: updateVoting,
                        showSelectedIcon: false,
                        emptySelectionAllowed: true,
                      ),
                      Wrap(
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: post.content));
                              var snackbar = SnackBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                duration: const Duration(seconds: 3),
                                content: AwesomeSnackbarContent(
                                  // ignore: use_build_context_synchronously
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  title: 'Copied to clipboard',
                                  message: 'Ctrl + V to win your argument',
                                  contentType: ContentType.success,
                                ),
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackbar);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            label: Text(_copyButtonText),
                            icon: const Icon(Icons.copy),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            label: const Text('Bookmark'),
                            icon: const Icon(Icons.bookmark_border),
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
