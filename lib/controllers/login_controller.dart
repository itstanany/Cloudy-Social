// lib/controllers/login_controller.dart
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_events.dart';
import 'package:social_feed_app/config/route_names.dart';
import 'package:social_feed_app/models/login_form_model.dart';

class LoginController {
  final AuthBloc _authBloc;

  LoginController(this._authBloc);

  void login(LoginFormModel form) {
    _authBloc.add(
      SignInRequested(
        form.username,
        form.password,
      ),
    );
  }

  void navigateToSignup(BuildContext context) {
    context.go(RouteNames.signup);
  }
}
