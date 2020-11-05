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
  final DateTime now = DateTime.now();
  int totalTimeSoFar = 0;
  StudentDriver student = null;
  final int STUDENT_ALL_HOURS = 2700;

  @override
  Widget build(BuildContext context) {
    final StudentDriverDetailsArgs args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Driver summary"),
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

              student = snapshot.data[0];
              List<DrivenTime> drivenTimesList = snapshot.data[1].reversed
                  .toList();

              return ListView.builder(
                itemCount: drivenTimesList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          Text(
                            "${student.firstName} ${student.lastName}",
                            style: TextStyle(fontSize: 32),
                          ),
                          Text(
                            _getDrivenText(drivenTimesList),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(_getFutureDrivesTimeText(drivenTimesList),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                    );
                  }
                  return _lessonTile(drivenTimesList[index - 1]);
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

          var drivenTime = DrivenTime(
              null, args.id, DateTime.now().add(Duration(minutes: 90)), 90);

          await drivenTimeDao.insertTime(drivenTime);
          if(totalTimeSoFar + 90 >= STUDENT_ALL_HOURS) {
            final studentDao = (await StudentDriversDatabase.instance).studentDao;
            student.allHours = true;
            await studentDao.update(student);
          }
          setState(() {
            //empty to requery db
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _lessonTile(DrivenTime drivenTime) {
    bool isLessonInPast = drivenTime.lessonStartTime.isBefore(now);
    final textStyle = TextStyle(
        color: isLessonInPast ? Colors.grey[700] : Colors.black,
        fontSize: 20.0);
    final hintStyle = TextStyle(
        color: isLessonInPast ? Colors.grey[500] : Colors.grey[700],
        fontSize: 14.0);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      color: isLessonInPast ? Colors.grey[100] : Colors.grey[300],
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      _getFormattedDate(drivenTime
                          .lessonStartTime),
                      style: textStyle
                  ),
                  Text(
                      'Data',
                      style: hintStyle
                  ),
                ]),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      _getFormattedMinutes(drivenTime
                          .lessonDuration),
                      style: textStyle
                  ),
                  Text(
                      'Czas trwania',
                      style: hintStyle
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  String _getDrivenText(List<DrivenTime> drivenTimesList) {
    totalTimeSoFar = drivenTimesList
        .where((element) => element.lessonStartTime.isBefore(now))
        .fold(0, (value, element) => value + element.lessonDuration);
    int hours = totalTimeSoFar ~/ 60;
    int minutes = totalTimeSoFar % 60;

    String hoursDrivenText = _getFormattedHours(hours);
    String minutesDrivenText = "";
    if (minutes > 0) minutesDrivenText = "i ${_getFormattedMinutes(minutes)}";

    return "Wyjeżdzono $hoursDrivenText $minutesDrivenText";
  }

  String _getFutureDrivesTimeText(List<DrivenTime> drivenTimesList) {
    int futureTotalTimeSoFar = drivenTimesList
        .where((element) => element.lessonStartTime.isAfter(now))
        .fold(0, (value, element) => value + element.lessonDuration);
    int hours = futureTotalTimeSoFar ~/ 60;
    int minutes = futureTotalTimeSoFar % 60;

    String hoursDrivenText = _getFormattedHours(hours);
    String minutesDrivenText = "";
    if (minutes > 0) minutesDrivenText = "i ${_getFormattedMinutes(minutes)}";

    return "Zaplanowano $hoursDrivenText $minutesDrivenText";
  }

  String _getFormattedHours(int hours) {
    String hoursDrivenText = "";
    if (hours == 0 || hours >= 5)
      hoursDrivenText += "$hours godzin";
    else if (hours >= 1 && hours <= 4) hoursDrivenText += "$hours godziny";
    return hoursDrivenText;
  }

  String _getFormattedMinutes(int minutes) {
    String minutesDrivenText;
    if (minutes == 0)
      minutesDrivenText = "";
    else if (minutes == 1)
      minutesDrivenText = "$minutes minutę";
    else if (minutes <= 4)
      minutesDrivenText = "$minutes minuty";
    else if (minutes >= 5) minutesDrivenText = "$minutes minut";
    return minutesDrivenText;
  }

  String _getFormattedDate(DateTime date) {
    var hours = date.hour.toString().padLeft(2, "0");
    var minutes = date.minute.toString().padLeft(2, "0");
    var day = date.day.toString().padLeft(2, "0");
    var month = date.month.toString().padLeft(2, "0");
    var year = date.year;
    return "$hours:$minutes $day-$month-$year";
  }
}
