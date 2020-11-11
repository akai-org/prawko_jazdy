import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/database/StudentDriversDao.dart';
import 'package:prawkojazdy/database/database.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';
import 'package:prawkojazdy/pages/StudentDriverDetailsPage.dart';

import 'package:prawkojazdy/database/DrivenTimeDao.dart';

import 'StudentDriverAddPage.dart';

class StudentDriverListPage extends StatefulWidget {
  static const routeName = "/studentDriverList";

  @override
  State<StatefulWidget> createState() => _StudentDriverListState();
}

class _StudentDriverListState extends State<StudentDriverListPage> {
  final String title = 'Lista kursantów';
  Widget _appBarTitle;
  List studentsList = [];
  DrivenTimeDao _drivenTimeDao;
  StudentDriversDao _studentDao;
  bool isLoading = true;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);
  var _refreshKey = GlobalKey<RefreshIndicatorState>();

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
    _appBarTitle = Text(title);
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
                List filteredStudents = _searchText.isNotEmpty
                  ? studentsList.where((element) {
                    if (search.length == 1) {
                      return element.firstName
                        .toLowerCase()
                        .startsWith(search[0]) ||
                          element.lastName
                            .toLowerCase()
                            .startsWith(search[0]);
                    }
                    return element.firstName
                      .toLowerCase()
                      .startsWith(search[0]) &&
                        element.lastName
                          .toLowerCase()
                          .startsWith(search[1]);
                  }).toList()
                  : studentsList;

                if (isLoading) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }

                if (filteredStudents.length == 0) {
                  return Center(
                    child: Text('Nie znaleziono żadnych kursantów.'),
                  );
                }

                return studentsListWidget(filteredStudents);
              }
              ),
            ]
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {

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
      child: RefreshIndicator(
        key: _refreshKey,
        onRefresh: fetchStudents,
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
              )
            );
          }
        ),
      )
    );
  }

  Widget studentTile(StudentDriver student) {
    var color = Colors.white;
    if(student.allHours) color = Colors.green;
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, StudentDriverDetailsPage.routeName,
          arguments: StudentDriverDetailsArgs(
            student.id,
          ));
      },
      tileColor: color,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
          margin: EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
              '${student.firstName} ${student.lastName}',
              style: new TextStyle(fontSize: 20.0),
              maxLines: 1,
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text('Kategoria: ${student.category}')
          )
        ]
      )
    );
  }

  void showDeleteDialog(StudentDriver student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Usunąć ${student.firstName} ${student.lastName}?"),
          content: Text("Jesteś pewien, że chcesz usunąć tego kursanta?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Nie",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                "Tak",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                await _drivenTimeDao.deleteAllByStudentId(student.id);
                _studentDao.delete(student);
                setState(() {
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
            prefixIcon: new Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: 'Szukaj...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text(title);
        _filter.clear();
      }
    });
  }

  Future<void> fetchStudents() async {
    _refreshKey.currentState?.show();

    AppDatabase appDatabase = await StudentDriversDatabase.instance;
    _studentDao = appDatabase.studentDao;
    _drivenTimeDao = appDatabase.drivenTimeDao;

    final tempStudentsList = await _studentDao.queryAllStudents();

    setState(() {
      if(isLoading) isLoading = false;
      studentsList = tempStudentsList;
    });
  }
}
