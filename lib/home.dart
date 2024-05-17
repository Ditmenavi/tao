import 'package:flutter/material.dart';

import 'models/post.dart';

import 'utils/api_utils.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _counter = 0;
  Future<Post>? _copypastaFuture;

  void _fetchCopypasta() {
    setState(() {
      _copypastaFuture = getCopypasta(14);
    });
  }

  _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _fetchCopypasta,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Hello, World!'),
            Text('Clicked $_counter times!'),
            FutureBuilder<Post>(
              future: _copypastaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Text('Post ID: ${snapshot.data!.postId}'),
                      Text('Author: ${snapshot.data!.author}'),
                      Text('Title: ${snapshot.data!.title}'),
                      Text('Content: ${snapshot.data!.content}'),
                      Text('Category: ${snapshot.data!.category}'),
                      Text('Likes: ${snapshot.data!.likeCount}'),
                    ],
                  );
                } else {
                  return const Text('No data');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
