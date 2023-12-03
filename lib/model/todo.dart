import 'dart:convert';
import 'package:http/http.dart' as http;

// Future<ToDo> todoList() async {
//   try {
//     const apiUrl = 'http://10.0.2.2:1337/api/tasks';
//     final response = await http.get(Uri.parse(apiUrl));
//
//     if (response.statusCode == 200) {
//       // final jsonList = json.decode(response.body) as List;
//       // return jsonList.map((json) => ToDo.fromJson(json)).toList();
//       return ToDo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//
//     } else {
//       throw Exception('Failed to load Todos: ${response.statusCode}');
//     }
//   } catch (error) {
//     print(error);
//     throw Exception('Error occurred while loading toto');
//
//      // handle error gracefully
//   }
// }

Future<List<ToDo>> todoList() async {
  try {
    const apiUrl = 'http://10.0.2.2:1337/api/tasks';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body)['data'] as List;
      return jsonList.map((json) => _parseToDo(json['attributes'])).toList();
    } else {
      throw Exception('Failed to load Todos: ${response.statusCode}');
    }
  } catch (error) {
    print(error);
    throw Exception('Error occurred while loading todos.');
  }
}

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

ToDo _parseToDo(Map<String, dynamic> json) {
  return ToDo(
    id: json['id'].toString(), // Convert id to String
    title: json['title'],
    isDone: json['isDone'],
    date: DateTime.parse(json['date']), // Parse date string
  );
}