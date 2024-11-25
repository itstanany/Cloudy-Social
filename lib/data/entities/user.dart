import 'package:floor/floor.dart';

@entity
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'username')
  final String username;

  @ColumnInfo(name: 'password_hash')
  final String passwordHash;

  @ColumnInfo(name: 'first_name')
  final String firstName;

  @ColumnInfo(name: 'last_name')
  final String lastName;

  @ColumnInfo(name: 'date_of_birth')
  final String dateOfBirth;

  @ColumnInfo(name: "posts")
  final String posts;
  @ColumnInfo(name: 'profile_picture_path')
  final String? profilePicturePath;

  User({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.posts,
    this.profilePicturePath,
  });
}
