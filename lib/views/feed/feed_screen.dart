import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/bloc/post/post_state.dart';
import 'package:social_feed_app/config/route_names.dart';
import 'package:social_feed_app/controllers/feed_controller.dart';
import 'package:social_feed_app/data/entities/post.dart';
import 'package:social_feed_app/models/post_model.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';
import 'package:social_feed_app/services/post_sort_service.dart';
import 'package:social_feed_app/views/feed/widgets/post_card.dart';

// lib/views/screens/feed/feed_screen.dart
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late FeedController _controller;
  late String currentUsername;
  SortType _currentSortType = SortType.recent;

  @override
  void initState() {
    super.initState();
    _controller = FeedController(context.read<PostBloc>());
    _controller.loadPosts();
    currentUsername = AuthStorageService().getAuthenticatedUsername() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFAB(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Feed'),
      actions: [_buildSortMenu()],
    );
  }

  Widget _buildSortMenu() {
    return PopupMenuButton<SortType>(
      onSelected: (SortType type) {
        setState(() => _currentSortType = type);
      },
      itemBuilder: (context) => [
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
    );
  }

  Widget _buildBody() {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PostsLoaded) {
          final sortedPosts =
              _controller.sortPosts(state.posts, _currentSortType);
          return ListView.builder(
            itemCount: sortedPosts.length,
            itemBuilder: (context, index) => PostCardView(
              postModel: PostModel(sortedPosts[index]),
              currentUserUsername: currentUsername,
              onLike: () => _controller.likePost(sortedPosts[index]),
              onDelete: () => _controller.deletePost(sortedPosts[index]),
              onEdit: (String newBody) =>
                  _controller.editPost(sortedPosts[index], newBody),
            ),
          );
        }
        if (state is PostError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No posts yet'));
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => context.push(RouteNames.addPost),
      child: const Icon(Icons.add),
    );
  }
}
