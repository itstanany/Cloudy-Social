// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
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
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  PostDao? _postDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
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
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `first_name` TEXT NOT NULL, `last_name` TEXT NOT NULL, `date_of_birth` TEXT NOT NULL, `posts` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Post` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `body` TEXT NOT NULL, `likes` INTEGER NOT NULL, `imagePath` TEXT, `authorUsername` TEXT NOT NULL, `createdAt` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  PostDao get postDao {
    return _postDaoInstance ??= _$PostDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'date_of_birth': item.dateOfBirth,
                  'posts': item.posts
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'first_name': item.firstName,
                  'last_name': item.lastName,
                  'date_of_birth': item.dateOfBirth,
                  'posts': item.posts
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  @override
  Future<User?> findUserByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM User WHERE username = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            dateOfBirth: row['date_of_birth'] as String,
            posts: row['posts'] as String),
        arguments: [username]);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            username: row['username'] as String,
            password: row['password'] as String,
            firstName: row['first_name'] as String,
            lastName: row['last_name'] as String,
            dateOfBirth: row['date_of_birth'] as String,
            posts: row['posts'] as String));
  }

  @override
  Future<bool?> checkUsernameExists(String username) async {
    return _queryAdapter.query(
        'SELECT EXISTS(SELECT 1 FROM User WHERE username = ?1)',
        mapper: (Map<String, Object?> row) => (row.values.first as int) != 0,
        arguments: [username]);
  }

  @override
  Future<bool?> validateCredentials(
    String username,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT EXISTS(SELECT 1 FROM User WHERE username = ?1 AND password = ?2)',
        mapper: (Map<String, Object?> row) => (row.values.first as int) != 0,
        arguments: [username, password]);
  }

  @override
  Future<void> updateUserProfile(
    String username,
    String firstName,
    String lastName,
    String dateOfBirth,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE User SET first_name = ?2, last_name = ?3, date_of_birth = ?4 WHERE username = ?1',
        arguments: [username, firstName, lastName, dateOfBirth]);
  }

  @override
  Future<User?> getUserProfile(String username) async {
    return _queryAdapter.query(
        'SELECT first_name, last_name, date_of_birth FROM User WHERE username = ?1',
        mapper: (Map<String, Object?> row) => User(id: row['id'] as int?, username: row['username'] as String, password: row['password'] as String, firstName: row['first_name'] as String, lastName: row['last_name'] as String, dateOfBirth: row['date_of_birth'] as String, posts: row['posts'] as String),
        arguments: [username]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }
}

class _$PostDao extends PostDao {
  _$PostDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _postInsertionAdapter = InsertionAdapter(
            database,
            'Post',
            (Post item) => <String, Object?>{
                  'id': item.id,
                  'body': item.body,
                  'likes': item.likes,
                  'imagePath': item.imagePath,
                  'authorUsername': item.authorUsername,
                  'createdAt': item.createdAt
                }),
        _postUpdateAdapter = UpdateAdapter(
            database,
            'Post',
            ['id'],
            (Post item) => <String, Object?>{
                  'id': item.id,
                  'body': item.body,
                  'likes': item.likes,
                  'imagePath': item.imagePath,
                  'authorUsername': item.authorUsername,
                  'createdAt': item.createdAt
                }),
        _postDeletionAdapter = DeletionAdapter(
            database,
            'Post',
            ['id'],
            (Post item) => <String, Object?>{
                  'id': item.id,
                  'body': item.body,
                  'likes': item.likes,
                  'imagePath': item.imagePath,
                  'authorUsername': item.authorUsername,
                  'createdAt': item.createdAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Post> _postInsertionAdapter;

  final UpdateAdapter<Post> _postUpdateAdapter;

  final DeletionAdapter<Post> _postDeletionAdapter;

  @override
  Future<List<Post>> getAllPosts() async {
    return _queryAdapter.queryList('SELECT * FROM Post ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => Post(
            id: row['id'] as int?,
            body: row['body'] as String,
            likes: row['likes'] as int,
            imagePath: row['imagePath'] as String?,
            authorUsername: row['authorUsername'] as String,
            createdAt: row['createdAt'] as String?));
  }

  @override
  Future<List<Post>> getPostsByUser(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM Post WHERE authorId = ?1',
        mapper: (Map<String, Object?> row) => Post(
            id: row['id'] as int?,
            body: row['body'] as String,
            likes: row['likes'] as int,
            imagePath: row['imagePath'] as String?,
            authorUsername: row['authorUsername'] as String,
            createdAt: row['createdAt'] as String?),
        arguments: [userId]);
  }

  @override
  Future<Post?> getPostById(int postId) async {
    return _queryAdapter.query('SELECT * FROM Post WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Post(
            id: row['id'] as int?,
            body: row['body'] as String,
            likes: row['likes'] as int,
            imagePath: row['imagePath'] as String?,
            authorUsername: row['authorUsername'] as String,
            createdAt: row['createdAt'] as String?),
        arguments: [postId]);
  }

  @override
  Future<void> insertPost(Post post) async {
    await _postInsertionAdapter.insert(post, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePost(Post post) async {
    await _postUpdateAdapter.update(post, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePost(Post post) async {
    await _postDeletionAdapter.delete(post);
  }
}
