import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed_app/models/profile_model.dart';
import 'package:social_feed_app/services/image_service.dart';

class ProfilePicture extends StatelessWidget {
  final ProfileModel profile;
  final Function(String) onPictureUpdated;
  final ImagePicker _picker = ImagePicker();

  ProfilePicture({
    Key? key,
    required this.profile,
    required this.onPictureUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _getProfileImage(profile.user.profilePicturePath),
            child: profile.user.profilePicturePath == null
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
                onPressed: () => _updateProfilePicture(context),
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

  Future<void> _updateProfilePicture(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (pickedFile != null) {
        final imagePath = await ImageService.saveLocalImage(
          File(pickedFile.path),
        );
        onPictureUpdated(imagePath);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile picture')),
      );
    }
  }
}
