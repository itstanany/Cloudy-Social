import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_events.dart';
import 'package:social_feed_app/bloc/profile/profile_bloc.dart';
import 'package:social_feed_app/bloc/profile/profile_events.dart';
import 'package:social_feed_app/bloc/profile/profile_state.dart';
import 'package:social_feed_app/controllers/profile.controller.dart';
import 'package:social_feed_app/data/entities/user.dart';
import 'package:social_feed_app/models/profile_model.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';
import 'package:social_feed_app/views/profile/widgets/profile_picture.dart';
import 'package:social_feed_app/views/profile/widgets/profile_form.dart';
import 'package:intl/intl.dart';

// lib/views/screens/profile/profile_screen.dart
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController _controller;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateOfBirthController;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController(
      context.read<ProfileBloc>(),
      context.read<AuthBloc>(),
    );
    _initializeControllers();
    _loadProfile();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
  }

  void _loadProfile() {
    final username = AuthStorageService().getAuthenticatedUsername();
    if (username != null) {
      _controller.loadProfile(username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Profile'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showSignOutDialog(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileLoaded) {
          _updateControllers(state.user);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ProfilePicture(
                  profile: ProfileModel(user: state.user),
                  onPictureUpdated: (imagePath) {
                    _controller.updateProfilePicture(state.user, imagePath);
                  },
                ),
                const SizedBox(height: 24),
                ProfileForm(
                  profile: ProfileModel(user: state.user),
                  formKey: _formKey,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  dateOfBirthController: _dateOfBirthController,
                  onSubmit: _handleSubmit,
                  onDateSelected: (date) {
                    setState(() {
                      _dateOfBirthController.text =
                          DateFormat('dd/MM/yyyy').format(date);
                    });
                  },
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('Failed to load profile'));
      },
    );
  }

  void _updateControllers(User user) {
    if (_firstNameController.text != user.firstName) {
      _firstNameController.text = user.firstName;
    }
    if (_lastNameController.text != user.lastName) {
      _lastNameController.text = user.lastName;
    }
    if (_dateOfBirthController.text.isEmpty) {
      _dateOfBirthController.text =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(user.dateOfBirth));
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = context.read<ProfileBloc>().state;
      if (state is ProfileLoaded) {
        // Parse the displayed date format back to ISO8601
        final DateFormat displayFormat = DateFormat('dd/MM/yyyy');
        final DateTime date = displayFormat.parse(_dateOfBirthController.text);

        context.read<ProfileBloc>().add(
              UpdateProfile(
                User(
                  id: state.user.id,
                  username: state.user.username,
                  passwordHash: state.user.passwordHash,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  dateOfBirth: date.toIso8601String(),
                  posts: state.user.posts,
                  profilePicturePath: state.user.profilePicturePath,
                ),
              ),
            );
      }
    }
  }
}

void _showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              Navigator.of(context).pop();
            },
            child: const Text('Sign Out'),
          ),
        ],
      );
    },
  );
}
