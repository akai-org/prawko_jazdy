import 'package:flutter/material.dart';
import 'package:prawkojazdy/pages/LessonAddPage.dart';

import 'package:prawkojazdy/pages/StudentDriverListPage.dart';
import 'package:prawkojazdy/pages/StudentDriverAddPage.dart';
import 'package:prawkojazdy/pages/StudentDriverSummaryPage.dart';

void main() => runApp(new MyApp());

final routes = {
  //Lista kursantów
  '/': (BuildContext context) => new StudentDriverListPage(),
  //Dodanie kursanta
  '/studentdriver/add': (BuildContext context) => new StudentDriverAddPage(),
  //Szczegóły kursanta (w tym lista jazd)
  '/studentdriver': (BuildContext context) => new StudentDriverSummaryPage(),
  //Dodanie jazdy kursanta
  '/lessons/add': (BuildContext context) => new LessonAddPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      initialRoute: '/',
      title: 'Prawko Jazdy',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}
