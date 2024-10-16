import 'package:go_router/go_router.dart';
import 'package:wagashi/screens/home.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MyHome();
      },
    )
  ],
);
