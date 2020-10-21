import 'package:floor/floor.dart' as floor;
import 'package:floor/floor.dart';

import 'models/StudentDriverModel.dart';

// build db after changes - flutter packages pub run build_runner build

@dao
abstract class StudentDriversDao {
  @insert
  Future<void> insertStudent(StudentDriver student);

  @Query('SELECT * from student_drivers WHERE id = :id')
  Future<StudentDriver> queryStudents(int id);

  @Query('SELECT * from student_drivers')
  Future<List<StudentDriver>> queryAllStudents();

  @floor.delete
  Future<void> delete(StudentDriver student);

  @floor.update
  Future<void> update(StudentDriver student);
}
