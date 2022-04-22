import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  late SharedPreferences sharedPreferences;
  String todo_lista_key = 'todo_list';

  // Métodos
  void saveTodoList(List lista) {
    final jsonString = json.encode(lista);
    sharedPreferences.setString(todo_lista_key, jsonString);
  }

  Future<List> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =
        sharedPreferences.getString(todo_lista_key) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded;
  }
}

class Todo {
  String title;
  DateTime dateTime;

  Todo({required this.title, required this.dateTime});

  // Construtor nomeado
  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']);

  //Metodo
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
    };
  }
}
