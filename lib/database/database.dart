import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'models/StudentDriverModel.dart';
import 'student_drivers_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [StudentDriver])
abstract class AppDatabase extends FloorDatabase {
  StudentDriversDao get studentDao;
}

// db singleton
class StudentDriversDatabase {
  StudentDriversDatabase._();

  static AppDatabase _instance;

  static Future<AppDatabase> get instance async {
    _instance ??=
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return _instance;
  }
}
