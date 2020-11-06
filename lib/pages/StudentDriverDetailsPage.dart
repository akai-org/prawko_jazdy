import 'package:flutter/material.dart';
import 'package:prawkojazdy/args/StudentDetailsArgs.dart';
import 'package:prawkojazdy/args/LessonAddPageArgs.dart';
import 'package:prawkojazdy/database/DrivenTimeDao.dart';
import 'package:prawkojazdy/database/StudentDriversDao.dart';
import 'package:prawkojazdy/database/database.dart';
import 'package:prawkojazdy/database/models/DrivenTimeModel.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';
import 'package:prawkojazdy/pages/LessonAddPage.dart';


class StudentDriverDetailsPage extends StatefulWidget {
  static const routeName = '/studentDriver/details';

  @override
  _StudentDriverDetailsPageState createState() =>
      _StudentDriverDetailsPageState();
}

class _StudentDriverDetailsPageState extends State<StudentDriverDetailsPage> {
  final DateTime now = DateTime.now();
  int totalTimeSoFar = 0;
  StudentDriver student;
  final int studentAllHours = 2700;
  StudentDriversDao _studentDriversDao;
  DrivenTimeDao _drivenTimeDao;
  bool isLoading = true;
  List<DrivenTime> drivenTimesList = [];
  StudentDriverDetailsArgs args;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchStudentDrivenTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil kursanta"),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: drivenTimesList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _studentSummary();
                }
                return _lessonTile(drivenTimesList[index - 1]);
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            dynamic result = await Navigator.pushNamed(
              context,
              LessonAddPage.routeName,
              arguments: new LessonAddPageArgs(action.add));

            if (result == null) return;

            var drivenTime = DrivenTime(
              null,
              args.id,
              result['lessonStartTime'],
              result['lessonDuration']
            );

            await _drivenTimeDao.insertTime(drivenTime);
            if(totalTimeSoFar + 90 >= studentAllHours) {
              student.allHours = true;
              await _studentDriversDao.update(student);
            }

            fetchStudentDrivenTime();
          },
        child: Icon(Icons.add),
      ),
    );
  }

  Padding _studentSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text(
            "${student.firstName} ${student.lastName}",
            style: TextStyle(fontSize: 32),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
            child: Text(
              _getDrivenText(),
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Text(
            _getFutureDrivesTimeText(),
            style: TextStyle(fontSize: 20.0)
          ),
          drivenTimesList.isEmpty
            ? Padding(
              padding: EdgeInsets.only(top: 50),
              child: Text('Nie przypisano żanych lekcji.')
            )
            : Container()
          ],
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
        onTap: () => lessonTileActionDialog(drivenTime),
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

  lessonTileActionDialog(DrivenTime drivenTime) {
    final formattedDate = _getFormattedDate(drivenTime.lessonStartTime);
    final time = formattedDate.substring(0, 5);
    final date = formattedDate.substring(6);
    final lessonDuration = _getFormattedMinutes(drivenTime.lessonDuration);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Co chcesz zrobić z lekcją?"),
          content: Text("Data: $date\nCzas rozpoczęcia: $time\nDługość lekcji: $lessonDuration"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Edytuj",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async {
                Navigator.pop(context);
                dynamic result = await Navigator.pushNamed(
                    context,
                    LessonAddPage.routeName,
                    arguments: new LessonAddPageArgs.withDrivenTime(
                      action.edit, drivenTime
                    ));

                if (result['lessonStartTime'] != drivenTime.lessonStartTime ||
                    result['lessonDuration'] != drivenTime.lessonDuration) {
                  print('force update');
                  drivenTime = DrivenTime(
                      drivenTime.id,
                      drivenTime.studentId,
                      result['lessonStartTime'],
                      result['lessonDuration']
                  );

                  await _drivenTimeDao.update(drivenTime);
                  fetchStudentDrivenTime();
                }
              },
            ),
            FlatButton(
              child: Text(
                "Usuń",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              onPressed: () async {
                await _drivenTimeDao.delete(drivenTime);
                setState(() {
                  drivenTimesList = List.from(drivenTimesList)
                    ..remove(drivenTime);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _getDrivenText() {
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

  String _getFutureDrivesTimeText() {
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

  Future<void> fetchStudentDrivenTime() async {
    setState(() {
      isLoading = true;
    });

    StudentDriverDetailsArgs tempArgs = ModalRoute.of(context).settings.arguments;
    AppDatabase appDatabase = await StudentDriversDatabase.instance;
    _studentDriversDao = appDatabase.studentDao;
    _drivenTimeDao = appDatabase.drivenTimeDao;

    final tempStudent = await _studentDriversDao.queryStudents(tempArgs.id);
    final tempDrivenTimesList = await _drivenTimeDao.
    queryAllDrivenTimesByStudentId(tempArgs.id);

    setState(() {
      args = tempArgs;
      student = tempStudent;
      drivenTimesList = tempDrivenTimesList.reversed.toList();
      isLoading = false;
    });
  }
}
