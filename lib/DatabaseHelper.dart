import 'package:flutter_todo/Task.dart';
import 'package:flutter_todo/TodoModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database db;

  Future database() async {
    return openDatabase(
      join(await getDatabasesPath(), "todo.db"),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE Task (id INTEGER PRIMARY KEY , title TEXT, description TEXT)');
        db.execute(
            'CREATE TABLE Todo (id INTEGER PRIMARY KEY , title TEXT, isDone INTEGER,taskId INTEGER)');
        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = -1;
    Database helper = await database();
    await helper
        .insert('Task', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> insertTodo(TodoModel todoModel) async {
    Database helper = await database();
    await helper.insert('Todo', todoModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTaskTitle(int taskId, String title) async {
    Database helper = await database();
    await helper
        .rawUpdate("UPDATE Task SET title ='$title' WHERE id = '$taskId'");
  }

  Future<void> updateTaskDescription(int taskId, String description) async {
    Database helper = await database();
    await helper.rawUpdate(
        "UPDATE Task SET description ='$description' WHERE id ='$taskId'");
  }

  Future<void> updateTodoTitle(int todoId, String description) async {
    Database helper = await database();
    await helper
        .rawUpdate("UPDATE Todo SET title ='$description' WHERE id='$todoId'");
  }

  Future<void> updateTodoIsDone(int todoId, int isDone) async {
    Database helper = await database();
    await helper
        .rawUpdate("UPDATE Todo SET isDone ='$isDone' WHERE id='$todoId'");
  }

  Future<void> deleteTask(int taskId) async {
    Database helper = await database();
    await helper.rawDelete("Delete From Task WHERE id='$taskId'");
    await helper.rawDelete("Delete From Todo WHERE taskId='$taskId'");
  }

  Future<List<Task>> getTasks() async {
    Database helper = await database();
    List<Map<String, dynamic>> tasks = await helper.query("Task");
    return List.generate(
      tasks.length,
      (index) {
        return Task(
          id: tasks[index]['id'] ?? "",
          title: tasks[index]['title'] ?? "",
          description: tasks[index]['description'] ?? "",
        );
      },
    );
  }

  Future<List<TodoModel>> getTodos(int id) async {
    Database helper = await database();
    List<Map<String, dynamic>> todo =
        await helper.rawQuery("SELECT * FROM Todo WHERE taskId = $id");
    return List.generate(
      todo.length,
      (index) {
        return TodoModel(
          id: todo[index]['id'] ?? "",
          title: todo[index]['title'] ?? "",
          isDone: todo[index]['isDone'] ?? "",
          taskId: todo[index]['taskId'] ?? "",
        );
      },
    );
  }
}
