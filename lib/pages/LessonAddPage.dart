import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prawkojazdy/args/LessonAddPageArgs.dart';

class LessonAddPage extends StatefulWidget {
  static const routeName = "/studentDriever/addLesson";

  @override
  _LessonAddPageState createState() => _LessonAddPageState();
}

class _LessonAddPageState extends State<LessonAddPage> {
  DateTime selectedDate;
  TimeOfDay selectedTime;
  int lessonHours = 1;
  int lessonMinutes = 0;
  TextEditingController dateFieldController = TextEditingController();
  TextEditingController timeFieldController = TextEditingController();
  bool isValidate = false;
  LessonAddPageArgs pageArgs;

  getPageType() {
    LessonAddPageArgs tmpPageArgs = ModalRoute.of(context).settings.arguments;
    setState(() {
      pageArgs = tmpPageArgs;

      if(tmpPageArgs.actionType == action.edit) {
        selectedDate = tmpPageArgs.lessonToEdit.lessonStartTime;

        TimeOfDay tmpTime = TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);
        selectedTime = tmpTime;

        dateFieldController.text = _getFormattedDate(selectedDate);
        timeFieldController.text = _getFormattedTime(selectedDate);

        int tmpDuration = tmpPageArgs.lessonToEdit.lessonDuration;
        lessonMinutes = tmpDuration % 60;
        lessonHours = (tmpDuration / 60).floor();

        isValidate = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pageArgs == null) getPageType();
    return Scaffold(
      appBar: AppBar(
        title: Text(pageArgs.pageTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            datePickerField(context),
            SizedBox(height: 18),
            timePickerField(context),
            SizedBox(height: 30),
            lessonDurationPicker(),
            SizedBox(height: 30),
            confirmButton()
          ]
        ),
      ),
    );
  }

  lessonDurationPicker() {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text('Czas trwania',
                style: TextStyle(fontSize: 18.0, color: Colors.grey[700])
            )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            hoursPicker(),
            minutePicker()
          ],
        ),
      ],
    );
  }

  validateForm () {
    if (selectedDate == null ||
        selectedTime == null ||
        (lessonHours + lessonMinutes) == 0) {
      setState(() {
        isValidate = false;
      });
    } else {
      setState(() {
        isValidate = true;
      });
    }
  }

  confirmButton() {
    return RaisedButton(
        child: Text(pageArgs.buttonText, style: TextStyle(fontSize: 18, color: Colors.white)),
        onPressed: isValidate
          ? () {
            final lessonDurationInMinutes = (lessonHours * 60) + lessonMinutes;
            final lessonStartTime = new DateTime(
                selectedDate.year, selectedDate.month, selectedDate.day,
                selectedTime.hour, selectedTime.minute
            );
            Navigator.pop(context, {
              'lessonStartTime': lessonStartTime,
              'lessonDuration': lessonDurationInMinutes
            });
          }
          : null,
      color: Colors.blue,
    );
  }

  hoursPicker() {
    return Row(
      children: [
        DropdownButton<String>(
            hint: Text("Godzin"),
            value: lessonHours.toString(),
        items: <String>['0', '1', '2', '3', '4', '5', '6']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value, style: TextStyle(fontSize: 18.0)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            lessonHours = int.parse(value);
          });
          validateForm();
        }),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('h', style: TextStyle(fontSize: 18.0)),
        ),
      ],
    );
  }

  minutePicker() {
  return Row(
    children: [
      DropdownButton<String>(
        hint: Text("Minut"),
        value: lessonMinutes.toString(),
        items: <String>['0', '15', '30', '45']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value, style: TextStyle(fontSize: 18.0)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            lessonMinutes = int.parse(value);
          });
          validateForm();
        }),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text('min', style: TextStyle(fontSize: 18.0)),
      ),
    ],
  );
  }

  TextField timePickerField(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 18.0),
      controller: timeFieldController,
      decoration: InputDecoration(labelText:'Czas rozpoczęcia'),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context);
      }, // Refer step 3
    );
  }

  TextField datePickerField(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 18.0),
      controller: dateFieldController,
      decoration: InputDecoration(labelText:'Data'),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      }, // Refer step 3
    );
  }

  _selectTime(BuildContext context) async {
    final currentTime = TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: currentTime
    );
    if (picked != null && picked != selectedTime) {
      final now = new DateTime.now();
      final tmpDate = new DateTime(now.year, now.month, now.day,
          picked.hour, picked.minute);
      setState(() {
        selectedTime = picked;
        timeFieldController.text = _getFormattedTime(tmpDate);
      });
      validateForm();
    }
  }

  _selectDate(BuildContext context) async {
    final currentTime = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: currentTime, // Refer step 1
      firstDate: currentTime,
      lastDate: new DateTime(currentTime.year + 5, currentTime.month, currentTime.day),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateFieldController.text = _getFormattedDate(picked);
      });
      validateForm();
    }
  }

  String _getFormattedDate(DateTime date) {
    var day = date.day.toString().padLeft(2, "0");
    var month = date.month.toString().padLeft(2, "0");
    var year = date.year;
    return "$day-$month-$year";
  }

  String _getFormattedTime(DateTime date) {
    var hours = date.hour.toString().padLeft(2, "0");
    var minutes = date.minute.toString().padLeft(2, "0");
    return "$hours:$minutes";
  }
}
