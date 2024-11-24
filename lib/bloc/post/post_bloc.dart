import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/bloc/post/post_state.dart';
import 'package:social_feed_app/data/dao/post_dao.dart';
import 'package:social_feed_app/data/database/database_singleton.dart';
import 'package:social_feed_app/data/entity/post_entity.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostDao _postDao;

  PostBloc(this._postDao) : super(PostInitial()) {
    on<LoadPosts>(_onLoadPosts);
    on<AddPost>(_onAddPost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
    on<LikePost>(_onLikePost);
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await _postDao.getAllPosts();
      debugPrint(posts.toString());
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final username = AuthStorageService().getAuthenticatedUsername();

      if (username == null) {
        throw Exception("Username Not Available!");
      }

      final post = Post(
        body: event.body,
        imagePath: event.imagePath,
        authorUsername: username,
      );

      await _postDao.insertPost(post);
      final posts = await _postDao.getAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onUpdatePost(UpdatePost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      await _postDao.updatePost(event.post);
      final posts = await _postDao.getAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      await _postDao.deletePost(event.post);
      final posts = await _postDao.getAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onLikePost(LikePost event, Emitter<PostState> emit) async {
    try {
      final updatedPost = Post(
        id: event.post.id,
        body: event.post.body,
        likes: event.post.likes + 1,
        imagePath: event.post.imagePath,
        authorUsername: event.post.authorUsername,
        createdAt: event.post.createdAt,
      );

      await _postDao.updatePost(updatedPost);
      final posts = await _postDao.getAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
