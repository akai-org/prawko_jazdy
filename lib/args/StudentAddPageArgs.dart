import 'package:prawkojazdy/database/models/StudentDriverModel.dart';
import 'actionTypeEnum.dart';

class StudentAddPageArgs {
  final action actionType;
  StudentDriver studentToEdit;

  final editTitleText = 'Edytuj kursanta';
  final editButtonText = 'Zatwierdź';

  final addTitleText = 'Dodaj kursanta';
  final addButtonText = 'Dodaj';

  String get pageTitle {
    if (actionType == action.add)
      return addTitleText;
    else
      return editTitleText;
  }

  String get buttonText {
    if (actionType == action.add)
      return addButtonText;
    else
      return editButtonText;
  }

  StudentAddPageArgs.withStudentDriver(this.actionType, this.studentToEdit);

  StudentAddPageArgs(this.actionType);
}