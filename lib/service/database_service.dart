import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_test/service/todo_db.dart';

class DataBaseService {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initDB() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await ToDoDB().createTable(database);

  Future<void> deleteDatabase() async =>
      databaseFactory.deleteDatabase(await fullPath);
}
