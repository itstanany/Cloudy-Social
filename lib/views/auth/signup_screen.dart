// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_feed_app/bloc/signup/signup_bloc.dart';
import 'package:social_feed_app/bloc/signup/signup_events.dart';
import 'package:social_feed_app/bloc/signup/signup_state.dart';
import 'package:social_feed_app/config/route_names.dart';
import 'package:social_feed_app/config/router.dart';
import 'package:social_feed_app/controllers/signup_controller.dart';
import 'package:social_feed_app/models/signup_form_model.dart';

// lib/views/screens/auth/signup_screen.dart
class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final SignupController _controller;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _controller = SignupController(context.read<SignupBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text('Sign Up'));
  }

  Widget _buildBody() {
    return BlocListener<SignupBloc, SignupState>(
      listener: _handleStateChanges,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildFirstNameField(),
                const SizedBox(height: 16),
                _buildLastNameField(),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Username is required' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Password is required' : null,
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      decoration: const InputDecoration(
        labelText: 'First Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'First name is required' : null,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      decoration: const InputDecoration(
        labelText: 'Last Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? 'Last name is required' : null,
    );
  }

  Widget _buildDatePicker() {
    return OutlinedButton(
      onPressed: () => _handleDatePicker(),
      child: Text(_dateOfBirth != null
          ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
          : 'Select Date of Birth'),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is SignupLoading ? null : _handleSubmit,
          child: state is SignupLoading
              ? const CircularProgressIndicator()
              : const Text('Sign Up'),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, SignupState state) {
    if (state is SignupSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful!')),
      );
    } else if (state is SignupFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  Future<void> _handleDatePicker() async {
    final date = await _controller.selectDate(context, _dateOfBirth);
    if (date != null) {
      setState(() => _dateOfBirth = date);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final form = SignupFormModel(
        username: _usernameController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dateOfBirth: _dateOfBirth!,
      );
      _controller.submitSignup(form);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
