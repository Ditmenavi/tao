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
      DateFormat formatter = DateFormat('EEE d/M/y');
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

Future<List<Post>> getCopypastas(int page) async {
  var url = Uri.parse('https://api.ditmenavi.com/copypastas?offset=$page');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body); // Decode as a list
    List<Post> posts = [];
    if (data.isNotEmpty) {
      for (var postJson in data) {
        DateFormat formatter = DateFormat('EEE d/M/y');
        String formattedTimestamp = formatter.format(DateTime.parse(postJson['Timestamp']));
        posts.add(Post(
          postId: postJson['Id'],
          author: postJson['Name'],
          timestamp: formattedTimestamp,
          title: postJson['Name'], // Assuming 'Name' is used as the title
          content: postJson['Content'],
          category: postJson['Category'],
          likeCount: 0, // Set a default like count (or adjust based on your API)
        ));
      }
      return posts;
    } else {
      throw Exception('No copypastas found');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}');
  }
}
