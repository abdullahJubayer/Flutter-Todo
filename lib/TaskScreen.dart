import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/DatabaseHelper.dart';
import 'package:flutter_todo/Task.dart';
import 'package:flutter_todo/TodoModel.dart';
import 'package:flutter_todo/radio_button.dart';

class TaskScreen extends StatefulWidget {
  Task task;

  TaskScreen({this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  int taskId;
  String taskTitle;
  String taskDescription;
  String todoHint;
  FocusNode titleFocus;
  FocusNode descriptionFocus;
  FocusNode todoFocus;
  bool _visibility = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      this.taskId = widget.task.id;
      this.taskTitle = widget.task.title;
      this.taskDescription = widget.task.description;
      _visibility = true;
    }
    titleFocus = FocusNode();
    descriptionFocus = FocusNode();
    todoFocus = FocusNode();
  }

  @override
  void dispose() {
    titleFocus.dispose();
    descriptionFocus.dispose();
    todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper helper = DatabaseHelper();
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Image(
                            image:
                                AssetImage("assets/images/back_arrow_icon.png"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: titleFocus,
                          controller: TextEditingController()
                            ..text = taskTitle != null ? taskTitle : "",
                          decoration: InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (value) async {
                            if (value != "") {
                              if (taskId != null) {
                                await helper.updateTaskTitle(taskId, value);
                                setState(() {
                                  taskTitle = value;
                                });
                              } else {
                                Task task = Task(title: value);
                                taskId = await helper.insertTask(task);
                                setState(() {
                                  _visibility = true;
                                  taskTitle = value;
                                });
                              }
                            }
                            descriptionFocus.requestFocus();
                          },
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: _visibility,
                    child: TextField(
                      focusNode: descriptionFocus,
                      onSubmitted: (value) async {
                        if (value != "") {
                          if (taskId != null) {
                            await helper.updateTaskDescription(taskId, value);
                            setState(() {
                              taskId = taskId;
                              taskDescription = value;
                            });
                          }
                        }
                        todoFocus.requestFocus();
                      },
                      controller: TextEditingController()
                        ..text = taskDescription != null ? taskDescription : "",
                      decoration: InputDecoration(
                          hintText: "Enter Description Hare",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 24.0)),
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF86829D)),
                    ),
                  ),
                  Expanded(
                      child: FutureBuilder(
                    initialData: [],
                    future: helper.getTodos(taskId != null ? taskId : -1),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if (snapshot.data[index].isDone == 0) {
                                  await helper.updateTodoIsDone(
                                      snapshot.data[index].id, 1);
                                } else {
                                  await helper.updateTodoIsDone(
                                      snapshot.data[index].id, 0);
                                }
                                setState(() {});
                              },
                              child: RadioButton(
                                isDone: snapshot.data[index].isDone == 1
                                    ? true
                                    : false,
                                text: snapshot.data[index].title,
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return RadioButton(
                              isDone: false,
                              text: "Enter Todo",
                            );
                          },
                        );
                      }
                    },
                  )),
                  Visibility(
                    visible: _visibility,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFF86829D), width: 1.5),
                            borderRadius: BorderRadius.circular(6.0),
                            color: null,
                          ),
                          child: Image(
                              image:
                                  AssetImage("assets/images/check_icon.png")),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController()
                              ..text = todoHint,
                            focusNode: todoFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Your Todo",
                            ),
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (taskId != null && taskId != -1) {
                                  TodoModel todo = TodoModel(
                                      title: value, isDone: 0, taskId: taskId);
                                  await helper.insertTodo(todo);
                                  setState(() {
                                    todoHint = "";
                                  });
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _visibility,
                child: Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () async {
                      await helper.deleteTask(taskId);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFFE3577),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Image(
                          image: AssetImage("assets/images/delete_icon.png")),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
