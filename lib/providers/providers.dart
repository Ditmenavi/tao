import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../utils/api_utils.dart';

final counterProvider = StateProvider((ref) => 0);

final copypastaProvider = FutureProvider.autoDispose<Post>((ref) async {
  return getCopypasta(1578);
});

var feedProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  return getCopypastas(1);
});

final votingProvider = StateProvider.family<Set<String>, String>((ref, postId) {
  return {};
});
