// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  StudentDriversDao _studentDaoInstance;

  DrivenTimeDao _drivenTimeDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `student_drivers` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `first_name` TEXT, `last_name` TEXT, `category` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `student_driven_time` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `studentId` INTEGER, `lesson_start_time` INTEGER, `lesson_duration` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  StudentDriversDao get studentDao {
    return _studentDaoInstance ??=
        _$StudentDriversDao(database, changeListener);
  }

  @override
  DrivenTimeDao get drivenTimeDao {
    return _drivenTimeDaoInstance ??= _$DrivenTimeDao(database, changeListener);
  }
}

class _$StudentDriversDao extends StudentDriversDao {
  _$StudentDriversDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _studentDriverInsertionAdapter = InsertionAdapter(
            database,
            'student_drivers',
            (StudentDriver item) => <String, dynamic>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'category': item.category
                }),
        _studentDriverUpdateAdapter = UpdateAdapter(
            database,
            'student_drivers',
            ['id'],
            (StudentDriver item) => <String, dynamic>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'category': item.category
                }),
        _studentDriverDeletionAdapter = DeletionAdapter(
            database,
            'student_drivers',
            ['id'],
            (StudentDriver item) => <String, dynamic>{
                  'id': item.id,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'category': item.category
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _student_driversMapper = (Map<String, dynamic> row) =>
      StudentDriver(row['id'] as int, row['first_name'] as String,
          row['last_name'] as String, row['category'] as String);

  final InsertionAdapter<StudentDriver> _studentDriverInsertionAdapter;

  final UpdateAdapter<StudentDriver> _studentDriverUpdateAdapter;

  final DeletionAdapter<StudentDriver> _studentDriverDeletionAdapter;

  @override
  Future<StudentDriver> queryStudents(int id) async {
    return _queryAdapter.query('SELECT * from student_drivers WHERE id = ?',
        arguments: <dynamic>[id], mapper: _student_driversMapper);
  }

  @override
  Future<List<StudentDriver>> queryAllStudents() async {
    return _queryAdapter.queryList('SELECT * from student_drivers',
        mapper: _student_driversMapper);
  }

  @override
  Future<void> insertStudent(StudentDriver student) async {
    await _studentDriverInsertionAdapter.insert(
        student, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(StudentDriver student) async {
    await _studentDriverUpdateAdapter.update(student, OnConflictStrategy.abort);
  }

  @override
  Future<void> delete(StudentDriver student) async {
    await _studentDriverDeletionAdapter.delete(student);
  }
}

class _$DrivenTimeDao extends DrivenTimeDao {
  _$DrivenTimeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _drivenTimeInsertionAdapter = InsertionAdapter(
            database,
            'student_driven_time',
            (DrivenTime item) => <String, dynamic>{
                  'id': item.id,
                  'studentId': item.studentId,
                  'lesson_start_time': item.lessonStartTime,
                  'lesson_duration': item.lessonDuration
                }),
        _drivenTimeUpdateAdapter = UpdateAdapter(
            database,
            'student_driven_time',
            ['id'],
            (DrivenTime item) => <String, dynamic>{
                  'id': item.id,
                  'studentId': item.studentId,
                  'lesson_start_time': item.lessonStartTime,
                  'lesson_duration': item.lessonDuration
                }),
        _drivenTimeDeletionAdapter = DeletionAdapter(
            database,
            'student_driven_time',
            ['id'],
            (DrivenTime item) => <String, dynamic>{
                  'id': item.id,
                  'studentId': item.studentId,
                  'lesson_start_time': item.lessonStartTime,
                  'lesson_duration': item.lessonDuration
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _student_driven_timeMapper = (Map<String, dynamic> row) =>
      DrivenTime(row['id'] as int, row['studentId'] as int,
          row['lesson_start_time'] as int, row['lesson_duration'] as int);

  final InsertionAdapter<DrivenTime> _drivenTimeInsertionAdapter;

  final UpdateAdapter<DrivenTime> _drivenTimeUpdateAdapter;

  final DeletionAdapter<DrivenTime> _drivenTimeDeletionAdapter;

  @override
  Future<DrivenTime> queryStudents(int id) async {
    return _queryAdapter.query('SELECT * from student_driven_time WHERE id = ?',
        arguments: <dynamic>[id], mapper: _student_driven_timeMapper);
  }

  @override
  Future<List<DrivenTime>> queryAllStudents() async {
    return _queryAdapter.queryList('SELECT * from student_driven_time',
        mapper: _student_driven_timeMapper);
  }

  @override
  Future<void> insertTime(DrivenTime drivenTime) async {
    await _drivenTimeInsertionAdapter.insert(
        drivenTime, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(DrivenTime drivenTime) async {
    await _drivenTimeUpdateAdapter.update(drivenTime, OnConflictStrategy.abort);
  }

  @override
  Future<void> delete(DrivenTime drivenTime) async {
    await _drivenTimeDeletionAdapter.delete(drivenTime);
  }
}
