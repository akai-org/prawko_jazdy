import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentDriverAddPage extends StatefulWidget {
  static const routeName = "/studentDriver/add";

  @override
  _StudentDriverAddPageState createState() => _StudentDriverAddPageState();
}

class _StudentDriverAddPageState extends State<StudentDriverAddPage> {
  final categoryPickerOptions = <String>['AM', 'A1', 'A2', 'A', 'B1', 'B'];
  String selectedCategory = 'B';
  String firstName = '';
  String lastName = '';
  final firstNameFieldController = TextEditingController();
  final lastNameFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final  validCharacters = RegExp(r'^[a-zA-Z]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj kursanta"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              firstNameField(),
              SizedBox(height: 18),
              lastNameField(),
              SizedBox(height: 30),
              categoryPicker(),
              SizedBox(height: 30),
              confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField firstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText:'Imię'),
      style: TextStyle(fontSize: 18.0),
      controller: firstNameFieldController,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      validator: (value) => validateField(value, "Imię"),
    );
  }

  TextFormField lastNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText:'Nazwisko'),
      style: TextStyle(fontSize: 18.0),
      controller: lastNameFieldController,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      validator: (value) => validateField(value, "Nazwisko"),
    );
  }

  validateField(value, label) {
    // Only letters 3-20, without numbers, special characters and digits.
    if (value.isEmpty) return 'To pole nie może być puste!';
    if (value.length < 3) return '$label za krótkie! Min. 3 litery.';
    if (value.length > 30) return '$label za długie! Max. 30 liter.';
    if (!validCharacters.hasMatch(value))
      return "$label nie może zawierać spacji, liczb ani znaków specjalnych!";

    return null;
  }

  confirmButton() {
    return RaisedButton(
      child: Text('Dodaj', style: TextStyle(fontSize: 18, color: Colors.white)),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          print(firstNameFieldController.text);
          print(lastNameFieldController.text);
          print(selectedCategory);
          Navigator.pop(context);
        }
      },
      color: Colors.blue,
    );
  }

  categoryPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text('Kategoria', style: TextStyle(fontSize: 18.0)),
        ),
        DropdownButton<String>(
          value: selectedCategory,
          items: categoryPickerOptions
            .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: new Text(value, style: TextStyle(fontSize: 18.0)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedCategory = value);
          }
        ),
      ],
    );
  }
}

/*
 _studentDao.insertStudent(StudentDriver(null, "Jan", "Kowalski", "A", false));
*/