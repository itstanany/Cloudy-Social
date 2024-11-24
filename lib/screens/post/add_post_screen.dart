import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/services/image_service.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageUrl = null;
          _imageUrlController.clear();
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(
                  labelText: 'Post Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Content is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'Enter image URL',
                ),
                onChanged: (value) {
                  setState(() {
                    _imageUrl = value.isEmpty ? null : value;
                    _imageFile = null;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Pick from Gallery'),
              ),
              if (_imageFile != null || _imageUrl != null) ...[
                SizedBox(height: 16),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.network(
                                _imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(child: Text('Invalid Image URL')),
                              ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _imageFile = null;
                            _imageUrl = null;
                            _imageUrlController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? imagePath;
      if (_imageFile != null) {
        imagePath = await ImageService.saveLocalImage(_imageFile!);
      } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
        imagePath = _imageUrl;
      }

      context.read<PostBloc>().add(
            AddPost(
              body: _bodyController.text,
              imagePath: imagePath,
            ),
          );
      context.pop();
    }
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
