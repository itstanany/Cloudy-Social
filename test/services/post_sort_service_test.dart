import 'package:flutter_test/flutter_test.dart';
import 'package:social_feed_app/data/entities/post.dart';
import 'package:social_feed_app/services/post_sort_service.dart';

void main() {
  group('PostSortService', () {
    late List<Post> testPosts;

    setUp(() {
      final now = DateTime.now();
      testPosts = [
        Post(
          id: 1,
          body: 'Test Post 1',
          likes: 10,
          authorUsername: 'user1',
          createdAt: now.subtract(const Duration(hours: 2)).toIso8601String(),
        ),
        Post(
          id: 2,
          body: 'Test Post 2',
          likes: 20,
          authorUsername: 'user2',
          createdAt: now.subtract(const Duration(hours: 1)).toIso8601String(),
        ),
        Post(
          id: 3,
          body: 'Test Post 3',
          likes: 5,
          authorUsername: 'user3',
          createdAt: now.toIso8601String(),
        ),
      ];
    });

    test('sortPosts with recent type should sort by date descending', () {
      final sorted = PostSortService.sortPosts(testPosts, SortType.recent);
      expect(sorted[0].id, equals(3));
      expect(sorted[1].id, equals(2));
      expect(sorted[2].id, equals(1));
    });

    test('sortPosts with popular type should sort by likes descending', () {
      final sorted = PostSortService.sortPosts(testPosts, SortType.popular);
      expect(sorted[0].id, equals(2));
      expect(sorted[1].id, equals(1));
      expect(sorted[2].id, equals(3));
    });

    test('sortPosts should not modify original list', () {
      final original = List<Post>.from(testPosts);
      PostSortService.sortPosts(testPosts, SortType.recent);
      for (var i = 0; i < testPosts.length; i++) {
        expect(testPosts[i].id, equals(original[i].id));
      }
    });
  });
}
