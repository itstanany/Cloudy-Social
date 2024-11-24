import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/bloc/post/post_state.dart';
import 'package:social_feed_app/config/RouteNames.dart';
import 'package:social_feed_app/data/entity/post_entity.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.addPost),
        child: Icon(Icons.add),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostsLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(post: post);
              },
            );
          }
          if (state is PostError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No posts yet'));
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            // leading: CircleAvatar(
            //   backgroundImage: CachedNetworkImageProvider(post.userAvatar),
            // ),
            title: Text(post.authorUsername),
            subtitle: Text(
              _getTimeAgo(DateTime.parse(post.createdAt)),
            ),
          ),
          if (post.imageUrl != null)
            CachedNetworkImage(
              imageUrl: post.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(post.body),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                LikeButton(
                  likes: post.likes,
                  onTap: () {
                    // Handle like action
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show post options
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class LikeButton extends StatelessWidget {
  final int likes;
  final VoidCallback onTap;

  const LikeButton({
    Key? key,
    required this.likes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.favorite_border),
            const SizedBox(width: 4),
            Text('$likes'),
          ],
        ),
      ),
    );
  }
}
