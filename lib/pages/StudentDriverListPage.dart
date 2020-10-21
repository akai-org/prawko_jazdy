import 'package:flutter/material.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';
import 'package:prawkojazdy/pages/StudentDriverDetailsPage.dart';

import 'StudentDriverAddPage.dart';

class StudentDriverListPage extends StatelessWidget {
  static const routeName = "/studentDriverList";

  List<StudentDriver> items = [
    StudentDriver(1, "Jan", "Kowalski", "A"),
    StudentDriver(1, "Antoni", "Kowalski", "A")
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("StudentDriverList"),
      ),
      body:
          // new Column(
          //   children: <Widget>[
          //     RaisedButton(
          //       child: Text('Dodaj studenta'),
          //       onPressed: () {
          //         // Navigate to the second screen using a named route.
          //         Navigator.pushNamed(context, '/studentdriver/add');
          //       },
          //     ),
          //     RaisedButton(
          //       child: Text('Podgląd studenta'),
          //       onPressed: () {
          //         // Navigate to the second screen using a named route.
          //         Navigator.pushNamed(context, '/studentdriver');
          //       },
          //     ),
          //     RaisedButton(
          //       child: Text('Dodaj jazdę'),
          //       onPressed: () {
          //         // Navigate to the second screen using a named route.
          //         Navigator.pushNamed(context, '/lessons/add');
          //       },
          //     ),
          //   ],
          // ),
          ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    child: ListTile(
                        title: Text(items[index].firstName +
                            " " +
                            items[index].lastName)),
                    onTap: () => {
                          Navigator.pushNamed(
                              context, StudentDriverDetailsPage.routeName,
                              arguments:
                                  StudentDriverDetailsArgs(items[index].id))
                        });
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, StudentDriverAddPage.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
