import 'package:floor/floor.dart';

// build db after changes - flutter packages pub run build_runner build

// data model class
@Entity(tableName: 'student_driven_time')
class DrivenTime {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int studentId;
  @ColumnInfo(name: 'lesson_start_time')
  final int lessonStartTime;
  @ColumnInfo(name: 'lesson_duration')
  final int lessonDuration;

  DrivenTime(
      this.id, this.studentId, this.lessonStartTime, this.lessonDuration);

  @override
  String toString() {
    return '$id $studentId $lessonStartTime $lessonDuration';
  }
}
