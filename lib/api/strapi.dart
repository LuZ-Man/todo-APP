import 'dart:convert';
import 'dart:async';

import 'package:todo_app/model/todo.dart';
import 'package:http/http.dart' as http;

Future<ToDo> fetchTasks() async {
  final response = await http
      .get(Uri.parse('http://localhost:1337/api/tasks'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ToDo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Task');
  }
}