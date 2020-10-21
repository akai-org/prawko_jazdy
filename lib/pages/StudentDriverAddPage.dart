import 'package:flutter/material.dart';

class StudentDriverAddPage extends StatelessWidget {
  static const routeName = "/studentDriver/add";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add student"),
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
