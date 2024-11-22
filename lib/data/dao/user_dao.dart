import 'package:floor/floor.dart';
import '../entity/user_entity.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User WHERE username = :username')
  Future<User?> findUserByUsername(String username);

  @insert
  Future<void> insertUser(User user);

  @Query('SELECT * FROM User')
  Future<List<User>> getAllUsers();

  @Query('SELECT EXISTS(SELECT 1 FROM User WHERE username = :username)')
  Future<bool?> checkUsernameExists(String username);
}
