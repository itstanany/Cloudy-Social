import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'username')
  final String username;

  @ColumnInfo(name: 'password')
  final String password;

  @ColumnInfo(name: 'first_name')
  final String firstName;

  @ColumnInfo(name: 'last_name')
  final String lastName;

  @ColumnInfo(name: 'date_of_birth')
  final String dateOfBirth;

  @ColumnInfo(name: "posts")
  final String posts;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.posts,
  });
}
