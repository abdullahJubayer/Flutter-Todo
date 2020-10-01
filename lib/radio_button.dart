import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  final bool isDone;
  final String text;
  RadioButton({@required this.isDone, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
              border: isDone
                  ? null
                  : Border.all(color: Color(0xFF86829D), width: 1.5),
              borderRadius: BorderRadius.circular(6.0),
              color: isDone ? Color(0xFF7349FE) : null,
            ),
            child: Image(image: AssetImage("assets/images/check_icon.png")),
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  color: isDone ? Color(0xFF7349FE) : Color(0xFF86829D),
                  fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }
}
