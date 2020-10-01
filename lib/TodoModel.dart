class TodoModel {
  int id;
  String title;
  int isDone;
  int taskId;

  TodoModel({this.id, this.title, this.isDone, this.taskId});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'isDone': isDone,
      'taskId': taskId
    };
    return data;
  }
}
