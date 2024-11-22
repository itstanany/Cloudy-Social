import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('Feed'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Add new post logic
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => PostCard(
                  post: _getDummyPost(),
                ),
                childCount: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Post _getDummyPost() {
    return Post(
      id: '1',
      username: 'John Doe',
      userAvatar: 'https://picsum.photos/50',
      content: 'This is a sample post content',
      imageUrl: 'https://picsum.photos/400/300',
      likes: 42,
      timestamp: DateTime.now(),
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
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(post.userAvatar),
            ),
            title: Text(post.username),
            subtitle: Text(
              _getTimeAgo(post.timestamp),
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
            child: Text(post.content),
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

class Post {
  final String id;
  final String username;
  final String userAvatar;
  final String content;
  final String? imageUrl;
  final int likes;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.timestamp,
  });
}
