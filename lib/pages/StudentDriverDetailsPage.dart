import 'package:flutter/material.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/database/DrivenTimeDao.dart';
import 'package:prawkojazdy/database/StudentDriversDao.dart';
import 'package:prawkojazdy/database/database.dart';
import 'package:prawkojazdy/database/models/DrivenTimeModel.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';

class StudentDriverDetailsPage extends StatefulWidget {
  static const routeName = '/studentDriver/details';

  @override
  _StudentDriverDetailsPageState createState() =>
      _StudentDriverDetailsPageState();
}

class _StudentDriverDetailsPageState extends State<StudentDriverDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final StudentDriverDetailsArgs args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Driver summary ${args.id}"),
      ),
      body: FutureBuilder(
        future: StudentDriversDatabase.instance,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          StudentDriversDao studentDriversDao = snapshot.data.studentDao;
          DrivenTimeDao drivenTimeDao = snapshot.data.drivenTimeDao;

          return FutureBuilder(
            future: Future.wait([
              studentDriversDao.queryStudents(args.id),
              drivenTimeDao.queryAllDrivenTimesByStudentId(args.id)
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done ||
                  !snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              StudentDriver student = snapshot.data[0];
              List<DrivenTime> drivenTimesList = snapshot.data[1];

              return ListView.builder(
                itemCount: drivenTimesList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Text(
                          "${student.firstName} ${student.lastName}",
                          style: TextStyle(fontSize: 32),
                        ),
                        Text("Liczba godzin -1")
                      ],
                    );
                  }
                  return lessonTile(drivenTimesList, index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final drivenTimeDao =
              (await StudentDriversDatabase.instance).drivenTimeDao;
          final duration = DateTime.fromMicrosecondsSinceEpoch(1)
              .add(Duration(hours: 1, minutes: 30));

          var drivenTime = DrivenTime(null, args.id, DateTime(2020), duration);
          await drivenTimeDao.insertTime(drivenTime);
          setState(() {
            //empty to requery db
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListTile lessonTile(List<DrivenTime> drivenTimesList, int index) {
    DrivenTime drivenTime = drivenTimesList[index - 1];
    Duration duration = Duration(
        milliseconds: drivenTime.lessonDuration.microsecondsSinceEpoch);
    return ListTile(
      title: Text(
          "Start ${drivenTime.lessonStartTime}, duration: ${duration.inHours}"),
    );
  }
}
