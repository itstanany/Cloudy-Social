import 'dart:async';
import 'package:floor/floor.dart';
import 'package:social_feed_app/data/dao/post_dao.dart';
import 'package:social_feed_app/data/entity/post_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import '../dao/user_dao.dart';
import '../entity/user_entity.dart';
part 'app_database.g.dart';

@Database(version: 1, entities: [User, Post])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  PostDao get postDao;
}
