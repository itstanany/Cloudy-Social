import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import '../dao/user_dao.dart';
import '../entity/user_entity.dart';
part 'app_database.g.dart';

@Database(version: 1, entities: [User])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
}
