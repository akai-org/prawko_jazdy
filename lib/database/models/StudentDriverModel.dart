// database table and column names
final String table = 'student_drivers';
final String columnId = '_id';
final String columnFirstName = 'first_name';
final String columnLastName = 'last_name';
final String columnCategory = 'category';

// data model class
class StudentDriver {
  int id;
  String first_name;
  String last_name;
  String category;

  StudentDriver();

  // convenience constructor to create a Word object
  StudentDriver.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    first_name = map[columnFirstName];
    last_name = map[columnLastName];
    category = map[columnCategory];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnFirstName: first_name,
      columnLastName: last_name,
      columnCategory: category
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
