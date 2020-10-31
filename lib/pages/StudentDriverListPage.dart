
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/database/StudentDriversDao.dart';
import 'package:prawkojazdy/database/database.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';
import 'package:prawkojazdy/pages/StudentDriverDetailsPage.dart';

import 'StudentDriverAddPage.dart';

class StudentDriverListPage extends StatefulWidget {
  static const routeName = "/studentDriverList";

  @override
  State<StatefulWidget> createState() => _StudentDriverListState();
}

class _StudentDriverListState extends State<StudentDriverListPage> {
  Widget _appBarTitle = new Text('Students List');
  List studentsList = [];
  StudentDriversDao _studentDao;
  bool isLoading = true;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);

  _StudentDriverListState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  void onReturnFromAddPage() {
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: _appBarTitle,
          actions: isLoading
              ? null
              : [
                  IconButton(
                    icon: _searchIcon,
                    onPressed: () => _searchPressed(),
                  )
                ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(builder: (context) {
                  final search = _searchText.toLowerCase().split(' ');
                  List filteredStudents = _searchText.isNotEmpty ? studentsList
                      .where((element) {
                    if (search.length == 1) {
                      return element.firstName.toLowerCase().startsWith(
                          search[0]) ||
                          element.lastName.toLowerCase().startsWith(search[0]);
                    }
                    return element.firstName.toLowerCase().startsWith(
                        search[0]) &&
                        element.lastName.toLowerCase().startsWith(search[1]);
                  }
                  ).toList() : studentsList;

                  if (isLoading) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (filteredStudents.length == 0) {
                    return Center(
                      child: Text('No Data Found'),
                    );
                  }

                  return studentsListWidget(filteredStudents);
                }),
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
          {
            _studentDao
                .insertStudent(StudentDriver(null, "Jan", "Kowalski", "A")),
            Navigator.pushNamed(context, StudentDriverAddPage.routeName)
                .then((_) => onReturnFromAddPage())
          },
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget studentsListWidget(List students) {
    return Expanded(
        child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => showDeleteDialog(students[index]),
                    ),
                  ],
                  child: Column(
                    children: <Widget>[
                      studentTile(students[index]),
                      Divider(
                        color: Colors.grey[300],
                        height: 1,
                      )
                    ],
                  ));
            }));
  }

  Widget studentTile(StudentDriver student) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, StudentDriverDetailsPage.routeName,
            arguments: StudentDriverDetailsArgs(
              student.id,
            ));
      },
      title: Text(
        '${student.firstName} ${student.lastName}',
        maxLines: 1,
      ),
    );
  }

  void showDeleteDialog(StudentDriver student) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete ${student.firstName} ${student.lastName}"),
          content: Text("Are sure to permanently delete this student?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "No",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                "Yes",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                _studentDao.delete(student);
                setState(() {
                  // studentsList.remove(student);
                  studentsList = List.from(studentsList)
                    ..remove(student);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          autofocus: true,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.black,),
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search Example');
        _filter.clear();
      }
    });
  }

  Future<void> fetchStudents() async {
    setState(() {
      isLoading = true;
    });

    AppDatabase appDatabase = await StudentDriversDatabase.instance;
    _studentDao = appDatabase.studentDao;

    final tempStudentsList = await _studentDao.queryAllStudents();

    setState(() {
      isLoading = false;
      studentsList = tempStudentsList;
    });
  }
}
