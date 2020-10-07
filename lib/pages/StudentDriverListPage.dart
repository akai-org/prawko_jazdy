import 'package:flutter/material.dart';

class StudentDriverListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("StudentDriverList"),
        ),
        body: new Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Dodaj studenta'),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/studentdriver/add');
              },
            ),
            RaisedButton(
              child: Text('Podgląd studenta'),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/studentdriver');
              },
            ),
            RaisedButton(
              child: Text('Dodaj jazdę'),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/lessons/add');
              },
            ),
          ],
        ));
  }
}
