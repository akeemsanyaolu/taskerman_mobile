import 'dart:convert';
import 'package:flutter_todo_list_app/features/tasks/models/task_data_ui_model.dart';
import 'package:http/http.dart' as http;

class TasksRepo {
  static Future<List<TaskDataUiModel>> fetchTasks() async {
    List<TaskDataUiModel> tasks = [];
    var response = await http.get(Uri.parse('http://10.0.2.2:8000/api/tasks'));
    List jsonResponse = jsonDecode(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      TaskDataUiModel task =
          TaskDataUiModel.fromJson(jsonResponse[i] as Map<String, dynamic>);
      tasks.add(task);
    }
    return tasks;
  }

  static Future<bool> addTask(
      String title, String description, bool complete) async {
    var request = {
      "title": title,
      "description": description,
      "complete": complete
    };
    var response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/tasks/create/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(request));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteTask(int id) async {
    var response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/tasks/delete/$id/'),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateTask(
      int id, String title, String description) async {
    var request = {"id": id, "title": title, "description": description};
    var response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/tasks/update/$id/'),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(request));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future getInitialTask(int id, String title, String description) async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/tasks/$id/'),
    );
    TaskDataUiModel jsonResponse = jsonDecode(response.body);
  }
}
