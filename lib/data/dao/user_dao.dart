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

  @Query(
      'SELECT EXISTS(SELECT 1 FROM User WHERE username = :username AND password = :password)')
  Future<bool?> validateCredentials(String username, String password);

  @update
  Future<void> updateUser(User user);

  @Query(
      'UPDATE User SET first_name = :firstName, last_name = :lastName, date_of_birth = :dateOfBirth WHERE username = :username')
  Future<void> updateUserProfile(
    String username,
    String firstName,
    String lastName,
    String dateOfBirth,
  );

  @Query(
      'SELECT first_name, last_name, date_of_birth FROM User WHERE username = :username')
  Future<User?> getUserProfile(String username);
}
