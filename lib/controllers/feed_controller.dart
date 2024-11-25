import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/data/entities/post.dart';
import 'package:social_feed_app/services/post_sort_service.dart';

class FeedController {
  final PostBloc _postBloc;

  FeedController(this._postBloc);

  void loadPosts() {
    _postBloc.add(LoadPosts());
  }

  void likePost(Post post) {
    _postBloc.add(LikePost(post));
  }

  void deletePost(Post post) {
    _postBloc.add(DeletePost(post));
  }

  void editPost(Post post, String newBody) {
    _postBloc.add(
      UpdatePost(
        Post(
          id: post.id,
          body: newBody,
          imagePath: post.imagePath,
          likes: post.likes,
          authorUsername: post.authorUsername,
          createdAt: post.createdAt,
        ),
      ),
    );
  }

  List<Post> sortPosts(List<Post> posts, SortType sortType) {
    return PostSortService.sortPosts(posts, sortType);
  }
}
