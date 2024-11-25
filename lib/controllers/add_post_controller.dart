import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/models/post_form_model.dart';
import 'package:social_feed_app/services/image_service.dart';

class AddPostController {
  final PostBloc _postBloc;
  final ImagePicker _picker;

  AddPostController(this._postBloc) : _picker = ImagePicker();

  Future<File?> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<void> submitPost(PostFormModel form) async {
    String? imagePath;
    if (form.imageFile != null) {
      imagePath = await ImageService.saveLocalImage(form.imageFile!);
    } else if (form.imageUrl != null && form.imageUrl!.isNotEmpty) {
      imagePath = form.imageUrl;
    }

    _postBloc.add(
      AddPost(
        body: form.body,
        imagePath: imagePath,
      ),
    );
  }
}
