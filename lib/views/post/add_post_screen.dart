import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';
import 'package:social_feed_app/controllers/add_post_controller.dart';
import 'package:social_feed_app/models/post_form_model.dart';
import 'package:social_feed_app/services/image_service.dart';

// lib/views/screens/add_post/add_post_screen.dart
class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late final AddPostController _controller;
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  final _imageUrlController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _controller = AddPostController(context.read<PostBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: const Text('Add Post'));
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildContentField(),
            const SizedBox(height: 16),
            _buildImageUrlField(),
            const SizedBox(height: 16),
            _buildImagePickerButton(),
            if (_imageFile != null || _imageUrl != null) _buildImagePreview(),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return TextFormField(
      controller: _bodyController,
      decoration: const InputDecoration(
        labelText: 'Post Content',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) =>
          value?.isEmpty ?? true ? 'Content is required' : null,
    );
  }

  Widget _buildImageUrlField() {
    return TextFormField(
      controller: _imageUrlController,
      decoration: const InputDecoration(
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
    );
  }

  Widget _buildImagePickerButton() {
    return ElevatedButton.icon(
      onPressed: _handleImagePick,
      icon: const Icon(Icons.photo_library),
      label: const Text('Pick from Gallery'),
    );
  }

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
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
              child: _buildImageWidget(),
            ),
            _buildImageRemoveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.contain,
        width: double.infinity,
      );
    }
    return Image.network(
      _imageUrl!,
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Text('Invalid Image URL')),
    );
  }

  Widget _buildImageRemoveButton() {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.white),
      onPressed: () {
        setState(() {
          _imageFile = null;
          _imageUrl = null;
          _imageUrlController.clear();
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _handleSubmit,
      child: const Text('Post'),
    );
  }

  Future<void> _handleImagePick() async {
    final pickedFile = await _controller.pickImage();
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _imageUrl = null;
        _imageUrlController.clear();
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final form = PostFormModel(
        body: _bodyController.text,
        imageUrl: _imageUrl,
        imageFile: _imageFile,
      );

      await _controller.submitPost(form);
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
