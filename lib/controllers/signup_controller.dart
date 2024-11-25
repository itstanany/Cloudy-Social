// lib/controllers/signup_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social_feed_app/bloc/signup/signup_bloc.dart';
import 'package:social_feed_app/bloc/signup/signup_events.dart';
import 'package:social_feed_app/models/signup_form_model.dart';

class SignupController {
  final SignupBloc _signupBloc;

  SignupController(this._signupBloc);

  void submitSignup(SignupFormModel form) {
    _signupBloc.add(
      SignupSubmitted(
        username: form.username,
        password: form.password,
        firstName: form.firstName,
        lastName: form.lastName,
        dateOfBirth: form.dateOfBirth,
      ),
    );
  }

  Future<DateTime?> selectDate(
      BuildContext context, DateTime? currentDate) async {
    return showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }
}
