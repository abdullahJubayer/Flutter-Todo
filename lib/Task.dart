class Task {
  int id;
  String title;
  String description;
  Task({this.id, this.title, this.description});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'description': description
    };
    return data;
  }
}
