import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/bloc/post/post_state.dart';
import 'package:social_feed_app/config/route_names.dart';
import 'package:social_feed_app/data/entity/post_entity.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';
import 'package:social_feed_app/services/post_sort_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late String currentUsername;
  SortType _currentSortType = SortType.recent;

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPosts());
    currentUsername = AuthStorageService().getAuthenticatedUsername() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          PopupMenuButton<SortType>(
            onSelected: (SortType type) {
              setState(() => _currentSortType = type);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: SortType.recent,
                child: Text('Most Recent'),
              ),
              const PopupMenuItem(
                value: SortType.popular,
                child: Text('Most Popular'),
              ),
              const PopupMenuItem(
                value: SortType.trending,
                child: Text('Trending'),
              ),
            ],
          ),
        ],
      ),
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
            final sortedPosts = PostSortService.sortPosts(
              state.posts,
              _currentSortType,
            );
            return ListView.builder(
              itemCount: sortedPosts.length,
              itemBuilder: (context, index) => PostCard(
                post: sortedPosts[index],
                currentUserUsername: currentUsername,
              ),
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
  final String currentUserUsername;

  const PostCard({
    Key? key,
    required this.post,
    required this.currentUserUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAuthor = post.authorUsername == currentUserUsername;
    return Dismissible(
      key: Key(post.id.toString()),
      direction: isAuthor ? DismissDirection.endToStart : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Post'),
              content: const Text('Are you sure you want to delete this post?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        context.read<PostBloc>().add(DeletePost(post));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(post.authorUsername),
              subtitle: Text(_getTimeAgo(DateTime.parse(post.createdAt))),
              trailing: isAuthor ? _buildOptionsMenu(context) : null,
            ),
            if (post.imagePath != null) _buildImageWidget(post.imagePath!),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(post.body),
            ),
            _buildActionBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          LikeButton(
            likes: post.likes,
            onTap: () {
              context.read<PostBloc>().add(LikePost(post));
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300,
      ),
      width: double.infinity,
      child: imagePath.startsWith('http')
          ? CachedNetworkImage(
              imageUrl: imagePath,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
            )
          : Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error),
              ),
            ),
    );
  }

  PopupMenuButton<String> _buildOptionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          _showEditDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController editController =
        TextEditingController(text: post.body);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: editController,
                decoration: const InputDecoration(
                  labelText: 'Post Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Content is required' : null,
              ),
              if (post.imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildImageWidget(post.imagePath!),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  context.read<PostBloc>().add(
                        UpdatePost(
                          Post(
                            id: post.id,
                            body: editController.text,
                            imagePath: post.imagePath,
                            likes: post.likes,
                            authorUsername: post.authorUsername,
                            createdAt: post.createdAt,
                          ),
                        ),
                      );
                  context.pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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

class LikeButton extends StatefulWidget {
  final int likes;
  final VoidCallback onTap;

  const LikeButton({
    Key? key,
    required this.likes,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 4),
            Text('${widget.likes}'),
          ],
        ),
      ),
    );
  }
}
