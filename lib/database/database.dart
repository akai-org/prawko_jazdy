import 'dart:async';

import 'package:floor/floor.dart';
import 'package:prawkojazdy/database/models/DrivenTimeModel.dart';
import 'package:prawkojazdy/database/student_driven_time_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:synchronized/synchronized.dart';

import 'models/StudentDriverModel.dart';
import 'student_drivers_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [StudentDriver, DrivenTime])
abstract class AppDatabase extends FloorDatabase {
  StudentDriversDao get studentDao;
  DrivenTimeDao get drivenTimeDao;
}

// db singleton
class StudentDriversDatabase {
  StudentDriversDatabase._();

  static AppDatabase _instance;
  static Lock lock = Lock();

  static final migration1to2 = Migration(1, 2, (database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS `student_driven_time` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `studentId` INTEGER, `lesson_start_time` INTEGER, `lesson_duration` INTEGER)');
  });

  static Future<AppDatabase> get instance async {
    await lock.synchronized(() async {
      _instance ??=
          await $FloorAppDatabase.databaseBuilder('app_database.db')
              .addMigrations([migration1to2])
              .build();
    });
    return _instance;
  }
}
