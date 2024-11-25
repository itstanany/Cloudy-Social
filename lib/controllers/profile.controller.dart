import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_events.dart';
import 'package:social_feed_app/bloc/profile/profile_bloc.dart';
import 'package:social_feed_app/bloc/profile/profile_events.dart';
import 'package:social_feed_app/data/entities/user.dart';
import 'package:social_feed_app/services/image_service.dart';

class ProfileController {
  final ProfileBloc _profileBloc;
  final AuthBloc _authBloc;
  final ImagePicker _picker;

  ProfileController(this._profileBloc, this._authBloc)
      : _picker = ImagePicker();

  void loadProfile(String username) {
    _profileBloc.add(LoadProfile(username));
  }

  void updateProfile(User user) {
    _profileBloc.add(UpdateProfile(user));
  }

  void updateProfilePicture(User currentUser, String imagePath) {
    _profileBloc.add(
      UpdateProfile(
        User(
          id: currentUser.id,
          username: currentUser.username,
          passwordHash: currentUser.passwordHash,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          dateOfBirth: currentUser.dateOfBirth,
          posts: currentUser.posts,
          profilePicturePath: imagePath,
        ),
      ),
    );
  }

  Future<String?> pickProfilePicture() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        return await ImageService.saveLocalImage(File(pickedFile.path));
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  void signOut() {
    _authBloc.add(SignOutRequested());
  }
}
