import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/auth/signup/signup_events.dart';
import 'package:social_feed_app/bloc/auth/signup/signup_state.dart';
import 'package:social_feed_app/data/database/database_singleton.dart';
import 'package:social_feed_app/data/entity/user_entity.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';

// lib/bloc/auth/signup/signup_bloc.dart
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final DatabaseSingleton _databaseSingleton = DatabaseSingleton();
  final AuthStorageService _authStorage = AuthStorageService();

  SignupBloc() : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        final database = await _databaseSingleton.database;
        final userDao = database.userDao;

        final exists = await userDao.checkUsernameExists(event.username);
        if (exists ?? false) {
          emit(SignupFailure('Username already exists'));
          return;
        }

        final user = User(
          username: event.username,
          password: event.password,
          firstName: event.firstName,
          lastName: event.lastName,
          dateOfBirth: event.dateOfBirth.toIso8601String(),
          posts: "",
        );

        await userDao.insertUser(user);
        _authStorage.saveAuthState(user.username);
        emit(SignupSuccess());
      } catch (error) {
        emit(SignupFailure(error.toString()));
      }
    });   
  }
}
