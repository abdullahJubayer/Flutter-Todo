import 'package:flutter/material.dart';
import 'package:flutter_todo/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
      ),
      home: Scaffold(body: HomePage()),
    );
  }
}
