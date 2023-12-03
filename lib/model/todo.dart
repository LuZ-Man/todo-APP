import 'dart:convert';
import 'package:http/http.dart' as http;

class ToDo {
  String id;
  String title;
  bool isDone;
  final DateTime date;

  ToDo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.date,
  });

  // static List<ToDo> todoList() {
  //   return [
  //     ToDo(id: '1', title: 'Make Bed', isDone: true, date: DateTime.now()),
  //     ToDo(id: '2', title: 'Make Coffee', date: DateTime.now()),
  //   ];
  // }

  static Future<List<ToDo>> todoList() async {
    try {
      const apiUrl = 'http://10.0.2.2:1337/api/tasks';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonList = json.decode(response.body) as List;
        return jsonList.map((json) => ToDo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Todos: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      return []; // handle error gracefully
    }
  }

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': String id,
      'title': String title,
      'isDone': bool isDone,
      'date': DateTime date,
      } =>
          ToDo(
            id: id,
            title: title,
            isDone: isDone,
            date: date,
          ),
      _ => throw const FormatException('Failed to load Tasks.'),
    };
  }
}

