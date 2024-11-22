import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String username;
  final String password;
  SignInRequested(this.username, this.password);
}

class SignOutRequested extends AuthEvent {}
