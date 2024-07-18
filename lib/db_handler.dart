
import 'package:path_provider/path_provider.dart';
//import 'package:pro/model.dart';
import 'package:todonew/model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DbHelper{
  static Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async{
    io.Directory documentDirectory = await  getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,'Todo.db');
    var db = await openDatabase(path,version: 1,onCreate: _createDatabase);
    return db;
  }
  _createDatabase(Database db, int version) async{

    await db.execute(
      "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT,title  TEXT NOT NULL,desc TEXT NOT NULL, dateanttime TEXT NOT NULL)",

    );
  }
  Future<ToDoModel> insert(ToDoModel toDoModel) async{
    var dbClient = await db;
    await dbClient?.insert('mytodo',toDoModel.toMap());
    return toDoModel;
  }

  Future<List<ToDoModel>> getDataList() async{
    await db;
    final QueryResult = await _db!.rawQuery('SELECT * FROM mytodo ');
    return QueryResult.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete('mytodo',where: 'id = ? ',whereArgs: [id]);
  }

  Future<int> update(ToDoModel toDoModel) async{
    var dbClient = await db;
    return await dbClient!.update('mytodo', toDoModel.toMap(),where: 'id : ? ',whereArgs: [toDoModel.id]);

  }
}