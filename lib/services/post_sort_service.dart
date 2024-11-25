import 'package:social_feed_app/data/entities/post.dart';

class PostSortService {
  static const double LIKES_WEIGHT = 1.0;
  static const double TIME_WEIGHT = 2.0;

  static List<Post> sortPosts(List<Post> posts, SortType sortType) {
    switch (sortType) {
      case SortType.recent:
        return _sortByDate(posts);
      case SortType.popular:
        return _sortByLikes(posts);
      case SortType.trending:
        return _sortByEngagement(posts);
      default:
        return _sortByDate(posts);
    }
  }

  static List<Post> _sortByDate(List<Post> posts) {
    return List.from(posts)
      ..sort((a, b) {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA);
      });
  }

  static List<Post> _sortByLikes(List<Post> posts) {
    return List.from(posts)..sort((a, b) => b.likes.compareTo(a.likes));
  }

  static List<Post> _sortByEngagement(List<Post> posts) {
    return List.from(posts)
      ..sort((a, b) {
        final scoreA = _calculateEngagementScore(a);
        final scoreB = _calculateEngagementScore(b);
        return scoreB.compareTo(scoreA);
      });
  }

  static double _calculateEngagementScore(Post post) {
    final timeDecay = _getTimeDecayFactor(post.createdAt);
    return (post.likes * LIKES_WEIGHT) * (timeDecay * TIME_WEIGHT);
  }

  static double _getTimeDecayFactor(String dateString) {
    final postDate = DateTime.parse(dateString);
    final now = DateTime.now();
    final hoursDifference = now.difference(postDate).inHours;
    return 1.0 / (1 + hoursDifference);
  }
}

enum SortType { recent, popular, trending }
