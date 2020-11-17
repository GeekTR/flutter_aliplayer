import 'package:sqflite/sqflite.dart';

class DBUtils {
  static final DBUtils _instance = DBUtils._privateConstructor();

  var _dbPath;
  Database _dataBase;

  DBUtils._privateConstructor() {}

  static DBUtils get instance {
    return _instance;
  }

  void openDB(String dbName, int vs) async {
    var databasePath = await getDatabasesPath();
    _dbPath = databasePath + "/" + dbName;
    _dataBase = await openDatabase(_dbPath, version: vs,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ");
    });
  }

  void deleteDB() async {
    await deleteDatabase(_dbPath);
  }

  void closeDB() async {
    await _dataBase.close();
  }

  void insert() async {
    //await _dataBase.insert(table, values);
  }

  void update() async {
    // await _dataBase.update(table, values);
  }

  void delete() async {
    // await _dataBase.delete(table);
  }

  void select() async {
    // await _dataBase.query(table);
  }
}
