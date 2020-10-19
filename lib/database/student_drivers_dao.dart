import 'package:floor/floor.dart' as floor;

import 'models/StudentDriverModel.dart';

// build db after changes - flutter packages pub run build_runner build

@floor.dao
abstract class StudentDriversDao {
  @floor.insert
  Future<void> insertStudent(StudentDriver student);

  @floor.Query('SELECT * from student_drivers WHERE id = :id')
  Future<StudentDriver> queryStudents(int student);

  @floor.Query('SELECT * from student_drivers')
  Future<List<StudentDriver>> queryAllStudents();

  @floor.delete
  Future<void> delete(StudentDriver student);

  @floor.update
  Future<void> update(StudentDriver student);
}
