import 'package:floor/floor.dart';
import 'package:social_feed_app/data/entity/post_entity.dart';

@dao
abstract class PostDao {
  @Query('SELECT * FROM Post ORDER BY createdAt DESC')
  Future<List<Post>> getAllPosts();

  @Query('SELECT * FROM Post WHERE authorId = :userId')
  Future<List<Post>> getPostsByUser(int userId);

  @insert
  Future<void> insertPost(Post post);

  @update
  Future<void> updatePost(Post post);

  @delete
  Future<void> deletePost(Post post);

  @Query('SELECT * FROM Post WHERE id = :postId')
  Future<Post?> getPostById(int postId);
}
