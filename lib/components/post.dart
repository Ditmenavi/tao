import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';

import '../models/post.dart';

class APost extends ConsumerStatefulWidget {
  final Post post;
  const APost({super.key, required this.post});

  @override
  ConsumerState<APost> createState() => _APostState();
}

class _APostState extends ConsumerState<APost> {
  final String _copyButtonText = 'Copy';
  Set<String> selected = {''};

  @override
  Widget build(BuildContext context) {
    var votingAsync = ref.watch(votingProvider(widget.post.postId.toString()));

    void updateVoting(Set<String> newSelection) {
      setState(() {
        selected = newSelection;
        ref.read(votingProvider(widget.post.postId.toString()).notifier).state = newSelection;
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
      child: GestureDetector(
        onTap: () {
          context.push('/post/${widget.post.postId}', extra: widget.post);
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
                    // Outer Row: Constrain this using Expanded
                    Expanded(
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                          ),
                          const SizedBox(width: 12), // Spacing between avatar and text
                          Expanded(
                            // Inner Row: Constrain it so the inner Column can fit properly
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.author,
                                  overflow: TextOverflow.fade, // Prevent overflow
                                  softWrap: false,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  widget.post.timestamp,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        widget.post.title,
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
                        widget.post.content,
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
                            await Clipboard.setData(ClipboardData(text: widget.post.content));
                            var snackbar = SnackBar(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              duration: const Duration(seconds: 3),
                              content: AwesomeSnackbarContent(
                                // ignore: use_build_context_synchronously
                                color: Theme.of(context).colorScheme.onSecondary,
                                title: 'Đã copy nội dung',
                                titleTextStyle:
                                    // ignore: use_build_context_synchronously
                                    TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.onSecondaryContainer),
                                message: 'Ctrl + V để vả vỡ mồm đối phương',
                                messageTextStyle:
                                    // ignore: use_build_context_synchronously
                                    TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSecondaryContainer),
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
    );
  }
}
