import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../utils/api_utils.dart';

final counterProvider = StateProvider((ref) => 0);

final copypastaProvider = FutureProvider.autoDispose<Post>((ref) async {
  return getCopypasta(1652);
});
