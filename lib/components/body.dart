import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

import 'feed.dart';

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
        const Feed(),
      ],
    );
  }
}
