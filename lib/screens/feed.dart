import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wagashi/utils/api_utils.dart';

import '../components/post.dart';
import '../models/post.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  static const _pageSize = 20;

  final PagingController<int, Post> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print('Fetching items for pageKey: $pageKey');
      final newItems = await getCopypastas(pageKey);

      // Debugging output
      print('Fetched ${newItems.length} items for pageKey: $pageKey');

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
        print('Appended last page');
      } else {
        final nextPageKey = pageKey + _pageSize; // Or change to pageKey + _pageSize for offset-based API
        _pagingController.appendPage(newItems, nextPageKey);
        print('Appended page $pageKey, next page key: $nextPageKey');
      }
    } catch (error) {
      _pagingController.error = error;
      print('Error fetching page: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Post>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Post>(
        itemBuilder: (context, post, index) => Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: APost(post: post),
          ),
        ),
      ),
    );
  }
}
