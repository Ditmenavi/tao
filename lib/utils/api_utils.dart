import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/post.dart';

Future<Post> getCopypasta(int id) async {
  var url = Uri.parse('https://api.ditmenavi.com/copypasta/$id');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body); // Decode as a list
    if (data.isNotEmpty) {
      final Map<String, dynamic> postJson = data[0]; // Get the first item
      DateFormat formatter = DateFormat('EEE M/d/y');
      String formattedTimestamp = formatter.format(DateTime.parse(postJson['Timestamp']));
      return Post(
        postId: postJson['Id'],
        author: postJson['Name'],
        timestamp: formattedTimestamp,
        title: postJson['Name'], // Assuming 'Name' is used as the title
        content: postJson['Content'],
        category: postJson['Category'],
        likeCount: 0, // Set a default like count (or adjust based on your API)
      );
    } else {
      throw Exception('Copypasta not found');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
