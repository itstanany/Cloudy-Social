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

  Post copyWith({
    int? id,
    String? body,
    int? likes,
    String? imagePath,
    String? authorUsername,
    String? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      body: body ?? this.body,
      likes: likes ?? this.likes,
      imagePath: imagePath ?? this.imagePath,
      authorUsername: authorUsername ?? this.authorUsername,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
