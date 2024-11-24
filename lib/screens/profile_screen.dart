import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_events.dart';
import 'package:social_feed_app/bloc/profile/profile_bloc.dart';
import 'package:social_feed_app/bloc/profile/profile_events.dart';
import 'package:social_feed_app/bloc/profile/profile_state.dart';
import 'package:social_feed_app/data/entity/user_entity.dart';
import 'package:social_feed_app/services/auth_storage_service.dart';
import 'package:social_feed_app/services/image_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateOfBirthController;
  DateTime? _selectedDate;
  final _picker = ImagePicker();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();

    final username = AuthStorageService().getAuthenticatedUsername();
    if (username != null) {
      context.read<ProfileBloc>().add(LoadProfile(username));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showSignOutDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '@${state.user.username}',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildProfilePicture(state.user),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateOfBirthController,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Failed to load profile'));
        },
      ),
    );
  }

  void _updateControllers(User user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _dateOfBirthController.text = user.dateOfBirth;
    _selectedDate = DateTime.parse(user.dateOfBirth);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  Widget _buildProfilePicture(User user) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _getProfileImage(user.profilePicturePath),
            child: user.profilePicturePath == null
                ? const Icon(Icons.person, size: 60)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _updateProfilePicture,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage(String? imagePath) {
    if (imagePath == null) return null;

    if (ImageService.isLocalImage(imagePath)) {
      return FileImage(File(imagePath));
    }
    return CachedNetworkImageProvider(imagePath);
  }

  Future<void> _updateProfilePicture() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (pickedFile != null) {
      final imagePath = await ImageService.saveLocalImage(
        File(pickedFile.path),
      );

      final state = context.read<ProfileBloc>().state;
      if (state is ProfileLoaded) {
        context.read<ProfileBloc>().add(
              UpdateProfile(
                User(
                  id: state.user.id,
                  username: state.user.username,
                  password: state.user.password,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  dateOfBirth: _dateOfBirthController.text,
                  posts: state.user.posts,
                  profilePicturePath: imagePath,
                ),
              ),
            );
      }
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = context.read<ProfileBloc>().state;
      if (state is ProfileLoaded) {
        context.read<ProfileBloc>().add(
              UpdateProfile(
                User(
                  id: state.user.id,
                  username: state.user.username,
                  password: state.user.password,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  dateOfBirth: _dateOfBirthController.text,
                  posts: state.user.posts,
                  profilePicturePath: state.user.profilePicturePath,
                ),
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
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
