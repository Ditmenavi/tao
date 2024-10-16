import 'package:go_router/go_router.dart';
import 'package:wagashi/components/feed.dart';
import 'package:wagashi/models/post.dart';
import 'package:wagashi/screens/home.dart';
import 'package:wagashi/screens/post_content.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (
        context,
        state,
        shell,
      ) =>
          MyHome(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Feed(),
            ),
            GoRoute(
              path: '/post/:Id',
              name: 'post',
              builder: (context, state) {
                final post = state.extra as Post;
                return PostContent(
                  post: post,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
