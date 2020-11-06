import 'package:floor/floor.dart';

// build db after changes - flutter packages pub run build_runner build

// data model class
@Entity(tableName: 'student_drivers')
class StudentDriver {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'first_name')
  final String firstName;

  @ColumnInfo(name: 'last_name')
  final String lastName;

  final String category;

  @ColumnInfo(name: 'all_hours')
  bool allHours;

  StudentDriver(
      this.id, this.firstName, this.lastName, this.category, this.allHours);

  @override
  String toString() {
    return '$id $firstName $lastName $category $allHours';
  }
}
