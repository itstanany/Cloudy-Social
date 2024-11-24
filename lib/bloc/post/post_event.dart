// lib/bloc/post/post_event.dart
import '../../data/entity/post_entity.dart';

abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final String body;
  final String? imagePath;
  final int? authorId;

  AddPost({
    required this.body,
    this.imagePath,
    this.authorId,
  });
}

class UpdatePost extends PostEvent {
  final Post post;

  UpdatePost(this.post);
}

class DeletePost extends PostEvent {
  final Post post;

  DeletePost(this.post);
}
