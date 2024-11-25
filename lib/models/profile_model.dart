import 'dart:io';

import 'package:social_feed_app/data/entities/user.dart';

class ProfileModel {
  final User user;
  final File? profileImage;

  ProfileModel({
    required this.user,
    this.profileImage,
  });

  String getFormattedDate() {
    return user.dateOfBirth.split('T')[0];
  }

  bool hasProfilePicture() {
    return user.profilePicturePath != null;
  }
}
