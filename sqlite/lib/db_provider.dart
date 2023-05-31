import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite/employee.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, 'employees_managerment.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE Employees ('
            'id INTEGER PRIMARY KEY'
            'name TEXT'
            'age INTEGER'
            ')');
      },
    );
  }

  Future<void> insertEmployee(Employee emp) async {
    await _database!.insert(
      'Employees',
      emp.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEmployee(Employee emp) async {
    await _database!.update(
      'Employees',
      emp.toMap(),
      where: 'id=?',
      whereArgs: [emp.id],
    );
  }

  Future<void> deleteEmployee(int id) async {
    await _database!.delete(
      'Employees',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<List<Employee>> employees() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Employees');
    return List.generate(
      maps.length,
      (index) => Employee(
        id: maps[index]['id'],
        name: maps[index]['name'],
        age: maps[index]['age'],
      ),
    );
  }
}
