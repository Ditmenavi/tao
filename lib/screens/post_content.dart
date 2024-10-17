import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:wagashi/models/post.dart';
import 'package:wagashi/providers/providers.dart';

class PostContent extends ConsumerStatefulWidget {
  final Post post;
  const PostContent({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostContentState();
}

class _PostContentState extends ConsumerState<PostContent> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.post.title} (${widget.post.postId})'),
        actions: [
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
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text(widget.post.author),
                            Text(widget.post.timestamp),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 0.5,
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
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: Text(
                            widget.post.content,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 12, 12),
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
                                    titleTextStyle: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        fontSize: 20,
                                        color: Theme.of(context).colorScheme.onSecondaryContainer),
                                    message: 'Ctrl + V để vả vỡ mồm đối phương',
                                    messageTextStyle: TextStyle(
                                        // ignore: use_build_context_synchronously
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSecondaryContainer),
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
        ),
      ),
    );
  }
}
