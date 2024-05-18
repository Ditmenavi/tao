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
  int _selectedIndex = 0;
  changeDestination(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider); // Access counter state directly
    final copypastaAsync = ref.watch(copypastaProvider);
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          onDestinationSelected: changeDestination,
          labelType: NavigationRailLabelType.all,
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FloatingActionButton(
              elevation: 0,
              hoverElevation: 2,
              onPressed: () {
                final result = ref.refresh(copypastaProvider.future); // Await the refresh
                if (result is AsyncError) {
                  print("Error fetching copypasta");
                } else {
                  print("Copypasta refreshed");
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
          destinations: const <NavigationRailDestination>[
            NavigationRailDestination(
              icon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.bookmark),
              label: Text('Favorites'),
            ),
          ],
        ),
        Expanded(
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
        ),
      ],
    );
  }
}
