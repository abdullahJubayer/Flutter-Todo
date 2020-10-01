import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/DatabaseHelper.dart';
import 'package:flutter_todo/TaskScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Color(0xFFF6F6F6),
        padding: EdgeInsets.all(24.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/logo.png"),
                ),
                Expanded(
                  child: FutureBuilder(
                    initialData: [],
                    future: databaseHelper.getTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskScreen(
                                      task: snapshot.data[index],
                                    ),
                                  ),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: NoteWidget(
                                title: snapshot.data[index].title ?? "Title",
                                description: snapshot.data[index].description ??
                                    "Description",
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return NoteWidget(
                              title: "Get Start",
                              description: "Description Hare",
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskScreen(
                        task: null,
                      ),
                    ),
                  ).then(
                    (value) {
                      setState(
                        () {},
                      );
                    },
                  );
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Image(image: AssetImage("assets/images/add_icon.png")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NoteWidget extends StatelessWidget {
  final String title;
  final String description;

  NoteWidget({@required this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
            child: Text(
              title ?? "Get Start",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.0, left: 10.0, right: 10.0),
            child: Text(
              description ?? "Description",
              style: TextStyle(
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
