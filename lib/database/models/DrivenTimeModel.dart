import 'package:floor/floor.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';

// build db after changes - flutter packages pub run build_runner build

// data model class
@Entity(
  tableName: 'student_driven_time',
  foreignKeys: [
    ForeignKey(
      childColumns: ['studentId'],
      parentColumns: ['id'],
      entity: StudentDriver,
      onDelete: ForeignKeyAction.cascade
    )
  ]
)
class DrivenTime {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final int studentId;

  @ColumnInfo(name: 'lesson_start_time')
  final DateTime lessonStartTime;

  @ColumnInfo(name: 'lesson_duration')
  final int lessonDuration;

  DrivenTime(
      this.id, this.studentId, this.lessonStartTime, this.lessonDuration);

  @override
  String toString() {
    return '$id $studentId $lessonStartTime $lessonDuration';
  }
}
