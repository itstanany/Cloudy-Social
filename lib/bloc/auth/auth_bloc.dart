import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_feed_app/bloc/auth/auth_events.dart';
import 'package:social_feed_app/bloc/auth/auth_state.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';
import 'dart:developer' as developer;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthStorageService _authStorage = AuthStorageService();

  AuthBloc() : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<CheckAuthStatus>(_checkAuthStatus);

    add(CheckAuthStatus());
  }

  Future<void> _checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    developer.log("inside check auth status");
    developer.log("inside 22 check auth status");
    if (_authStorage.isUserAuthenticated()) {
      debugPrint("inside if true");

      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
      debugPrint("inside if false");
    }
    debugPrint("after if");
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
// todo: auth logic goes here

      await _authStorage.saveAuthState(event.username);
      emit(AuthAuthenticated());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authStorage.clearAuthState();
    emit(AuthUnauthenticated());
  }
}
