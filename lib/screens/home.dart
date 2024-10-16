import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';

class MyHome extends ConsumerStatefulWidget {
  const MyHome({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  ConsumerState<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends ConsumerState<MyHome> {
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
    return Scaffold(
      body: Row(
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
                label: Text('Saved'),
              ),
            ],
          ),
          Expanded(child: widget.shell),
        ],
      ),
    );
  }
}
