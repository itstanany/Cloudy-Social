import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/signup/signup_events.dart';
import 'package:social_feed_app/bloc/signup/signup_state.dart';
import 'package:social_feed_app/data/database/database_singleton.dart';
import 'package:social_feed_app/data/entities/user.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';
import 'package:social_feed_app/services/password_hasher_service.dart';

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
        final hashedPassword =
            PasswordHasherService.hashPassword(event.password);

        final user = User(
          username: event.username,
          passwordHash: hashedPassword,
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
