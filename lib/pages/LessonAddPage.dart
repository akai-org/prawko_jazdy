import 'package:flutter/material.dart';

class LessonAddPage extends StatelessWidget {
  static const routeName = "/studentDriever/addLesson";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add lesson"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: Text('GPowrót!'),
        ),
      ),
    );
  }
}
