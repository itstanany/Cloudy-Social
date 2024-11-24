// lib/services/image_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageService {
  static const String IMAGE_DIRECTORY = 'post_images';

  static Future<String> saveLocalImage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/$IMAGE_DIRECTORY');

      // Create images directory if it doesn't exist
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Generate unique filename
      final fileName = '${const Uuid().v4()}${path.extension(imageFile.path)}';
      final savedImage = await imageFile.copy('${imageDir.path}/$fileName');

      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      throw Exception('Failed to save image');
    }
  }

  static Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error deleting image: $e');
    }
  }

  static bool isLocalImage(String imagePath) {
    return imagePath.startsWith('/') && imagePath.contains(IMAGE_DIRECTORY);
  }

  static Future<void> cleanupUnusedImages(List<String> usedImagePaths) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/$IMAGE_DIRECTORY');

      if (await imageDir.exists()) {
        await for (var entity in imageDir.list()) {
          if (entity is File && !usedImagePaths.contains(entity.path)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning up images: $e');
    }
  }
}
