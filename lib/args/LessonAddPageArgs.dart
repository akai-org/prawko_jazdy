import 'package:prawkojazdy/database/models/DrivenTimeModel.dart';
import 'actionTypeEnum.dart';

class LessonAddPageArgs {
  final action actionType;
  DrivenTime lessonToEdit;

  final editTitleText = 'Edytuj lekcję';
  final editButtonText = 'Zatwierdź';

  final addTitleText = 'Dodaj lekcję';
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

  LessonAddPageArgs.withDrivenTime(this.actionType, this.lessonToEdit);

  LessonAddPageArgs(this.actionType);
}