import 'dart:io';

class PostFormModel {
  final String body;
  final String? imageUrl;
  final File? imageFile;

  PostFormModel({
    required this.body,
    this.imageUrl,
    this.imageFile,
  });

  bool get hasImage => imageFile != null || (imageUrl?.isNotEmpty ?? false);
  bool get isValid => body.isNotEmpty;
}
