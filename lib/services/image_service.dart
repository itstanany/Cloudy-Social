// lib/services/image_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageService {
  static Future<String> saveLocalImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}${path.extension(imageFile.path)}';
    final savedImage = await imageFile.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  static bool isLocalImage(String imagePath) {
    return imagePath.startsWith('/');
  }
}
