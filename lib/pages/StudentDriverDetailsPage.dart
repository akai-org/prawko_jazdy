import 'package:flutter/material.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/pages/LessonAddPage.dart';

class StudentDriverDetailsPage extends StatelessWidget {
  static const routeName = '/studentDriver/details';

  @override
  Widget build(BuildContext context) {
    final StudentDriverDetailsArgs args =
        ModalRoute
            .of(context)
            .settings
            .arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Driver summary ${args.id}"),
      ),
      body: Column(children: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('GPowrót!'),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, LessonAddPage.routeName);
          },
          child: Text('Lessond add!'),
        )
      ]),
    );
  }
}
