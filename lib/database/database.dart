import 'dart:async';

import 'package:floor/floor.dart';
import 'package:prawkojazdy/database/DrivenTimeDao.dart';
import 'package:prawkojazdy/database/models/DrivenTimeModel.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:synchronized/synchronized.dart';

import 'converters/DateTimeConverter.dart';
import 'converters/BoolConverter.dart';
import 'models/StudentDriverModel.dart';
import 'StudentDriversDao.dart';

part 'database.g.dart'; // the generated code will be there


@TypeConverters([DateTimeConverter, BoolConverter])
@Database(version:  4, entities: [StudentDriver, DrivenTime])
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

  static final migration2to3 = Migration(2, 3, (database) async {
    await database.execute("DROP TABLE student_driven_time");
    await database.execute("CREATE TABLE IF NOT EXISTS `student_driven_time` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `studentId` INTEGER, `lesson_start_time` INTEGER, `lesson_duration` INTEGER, FOREIGN KEY (`studentId`) REFERENCES `student_drivers` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)");
  });

  static final migration3to4 = Migration(3, 4, (database) async {
    await database.execute("ALTER TABLE student_drivers ADD COLUMN all_hours INTEGER;");
    await database.execute("UPDATE student_drivers SET all_hours = 0;");
  });

  static Future<AppDatabase> get instance async {
    await lock.synchronized(() async {
      _instance ??=
          await $FloorAppDatabase.databaseBuilder('app_database.db')
              .addMigrations([migration1to2, migration2to3, migration3to4])
              .build();
    });
    return _instance;
  }
}
