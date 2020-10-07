import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prawkojazdy/database/models/StudentDriverModel.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "PrawkoJazdy.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $table (
                $columnId INTEGER PRIMARY KEY,
                $columnFirstName TEXT NOT NULL,
                $columnLastName TEXT NOT NULL,
                $columnCategory TEXT NOT NULL,
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(StudentDriver word) async {
    Database db = await database;
    int id = await db.insert(table, word.toMap());
    return id;
  }

  Future<StudentDriver> queryWord(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(table,
        columns: [columnId, columnFirstName, columnLastName, columnCategory],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return StudentDriver.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}
