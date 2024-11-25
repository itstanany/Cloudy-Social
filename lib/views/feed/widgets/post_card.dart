// lib/views/screens/feed/widgets/post_card_view.dart
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:social_feed_app/data/entities/post.dart';
import 'package:social_feed_app/models/post_model.dart';
import 'package:social_feed_app/views/feed/widgets/like_button.dart';

class PostCardView extends StatelessWidget {
  final PostModel postModel;
  final String currentUserUsername;
  final VoidCallback onLike;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const PostCardView({
    Key? key,
    required this.postModel,
    required this.currentUserUsername,
    required this.onDelete,
    required this.onLike,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAuthor = postModel.post.authorUsername == currentUserUsername;

    return Dismissible(
      key: Key(postModel.post.id.toString()),
      direction: isAuthor ? DismissDirection.endToStart : DismissDirection.none,
      background: _buildDeleteBackground(),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isAuthor, context),
            if (postModel.post.imagePath != null)
              _buildImage(postModel.post.imagePath!),
            _buildContent(),
            _buildActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  Widget _buildHeader(bool isAuthor, BuildContext context) {
    return ListTile(
      title: Text(postModel.post.authorUsername),
      subtitle: Text(postModel.getTimeAgo()),
      trailing: isAuthor ? _buildOptionsMenu(context) : null,
    );
  }

  Widget _buildImage(String imagePath) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
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

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(postModel.post.body),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          LikeButton(
            likes: postModel.post.likes,
            onTap: onLike,
          ),
          const Spacer(),
        ],
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
        TextEditingController(text: postModel.post.body);

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
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              if (postModel.post.imagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildImageWidget(postModel.post.imagePath!),
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
                  // Handle edit through callback
                  onEdit(editController.text);
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
}
