import 'app_database.dart';

class DatabaseSingleton {
  static final DatabaseSingleton _instance = DatabaseSingleton._internal();
  static AppDatabase? _database;

  factory DatabaseSingleton() => _instance;

  DatabaseSingleton._internal();

  Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<AppDatabase> _initDatabase() async {
    return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }
}
