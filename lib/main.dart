import 'package:flutter/material.dart';
import 'package:prawkojazdy/pages/LessonAddPage.dart';

import 'package:prawkojazdy/pages/StudentDriverListPage.dart';
import 'package:prawkojazdy/pages/StudentDriverAddPage.dart';
import 'package:prawkojazdy/pages/StudentDriverDetailsPage.dart';

void main() => runApp(new MyApp());

final routes = {
  //Lista kursantów
  StudentDriverListPage.routeName: (BuildContext context) =>
      new StudentDriverListPage(),
  //Dodanie kursanta
  StudentDriverAddPage.routeName: (BuildContext context) =>
      new StudentDriverAddPage(),
  //Szczegóły kursanta (w tym lista jazd)
  StudentDriverDetailsPage.routeName: (BuildContext context) =>
      new StudentDriverDetailsPage(),
  //Dodanie jazdy kursanta
  LessonAddPage.routeName: (BuildContext context) => new LessonAddPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: StudentDriverListPage.routeName,
      title: 'Prawko Jazdy',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}
