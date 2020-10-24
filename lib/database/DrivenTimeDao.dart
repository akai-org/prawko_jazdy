import 'package:floor/floor.dart' as floor;
import 'package:floor/floor.dart';
import 'package:prawkojazdy/database/models/DrivenTimeModel.dart';

@dao
abstract class DrivenTimeDao {
  @insert
  Future<void> insertTime(DrivenTime drivenTime);

  @Query('SELECT * from student_driven_time WHERE id = :id')
  Future<DrivenTime> queryStudents(int id);

  @Query('SELECT * from student_driven_time')
  Future<List<DrivenTime>> queryAllStudents();

  @floor.delete
  Future<void> delete(DrivenTime drivenTime);

  @floor.update
  Future<void> update(DrivenTime drivenTime);
}
