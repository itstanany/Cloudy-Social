import 'package:social_feed_app/data/entities/post.dart';

class PostModel {
  final Post post;

  PostModel(this.post);

  bool isAuthorPost(String username) => post.authorUsername == username;

  String getTimeAgo() {
    final difference =
        DateTime.now().difference(DateTime.parse(post.createdAt));
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
