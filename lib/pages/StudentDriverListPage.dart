import 'package:flutter/material.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/database/database.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';
import 'package:prawkojazdy/database/StudentDriversDao.dart';
import 'package:prawkojazdy/pages/StudentDriverDetailsPage.dart';

import 'StudentDriverAddPage.dart';

class StudentDriverListPage extends StatefulWidget {
  static const routeName = "/studentDriverList";
  String title = "Students List";

  StudentDriversDao _studentDao;

  List<StudentDriver> studentsList = [];

  Future<AppDatabase> database = StudentDriversDatabase.instance;

  @override
  State<StatefulWidget> createState() => _StudentDriverListState();
}

class _StudentDriverListState extends State<StudentDriverListPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<StudentDriversDao>(
                    future: getStudentDriverDao(),
                    builder: (BuildContext context,
                        AsyncSnapshot<StudentDriversDao> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.none) {
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return FutureBuilder<List<StudentDriver>>(
                            future: snapshot.data.queryAllStudents(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.none) {
                                return Container(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (widget.studentsList.length !=
                                    snapshot.data.length) {
                                  widget.studentsList = snapshot.data;
                                }

                                if (snapshot.data.length == 0) {
                                  return Center(
                                    child: Text('No Data Found'),
                                  );
                                }

                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                            child: ListTile(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      StudentDriverDetailsPage
                                                          .routeName,
                                                      arguments:
                                                          StudentDriverDetailsArgs(
                                                        snapshot.data[index].id,
                                                      ));
                                                },
                                                title: Text(
                                                  '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}',
                                                  maxLines: 1,
                                                )));
                                      }),
                                );
                              }
                            });
                      }
                    }),
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              {
                widget._studentDao.insertStudent(StudentDriver(null, "Jan", "Kowalski", "A")),
                Navigator.pushNamed(context, StudentDriverAddPage.routeName)
              },
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Future<StudentDriversDao> getStudentDriverDao() async {
    AppDatabase appDatabase = await widget.database;
    widget._studentDao = appDatabase.studentDao;
    return appDatabase.studentDao;
  }
}
