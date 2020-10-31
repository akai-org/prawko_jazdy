import 'package:floor/floor.dart';

class BoolConverter extends TypeConverter<bool, int> {
  @override
  bool decode(int databaseValue) {
    return databaseValue == 1;
  }

  @override
  int encode(bool value) {
    if (value) {
      return 1;
    } else {
      return 0;
    }
  }
}
