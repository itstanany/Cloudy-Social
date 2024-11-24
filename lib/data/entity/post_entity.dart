import 'package:floor/floor.dart';

@entity
class Post {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String body;
  final int likes;
  final String? imagePath;
  final String authorUsername;
  final String createdAt;

  Post({
    this.id,
    required this.body,
    this.likes = 0,
    this.imagePath,
    required this.authorUsername,
    String? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now().toIso8601String();
}
