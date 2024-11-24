// lib/screens/add_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_feed_app/bloc/post/post_bloc.dart';
import 'package:social_feed_app/bloc/post/post_event.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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

  void _submitPost() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<PostBloc>().add(
            AddPost(
              body: _bodyController.text,
              imageUrl: _imageUrl,
            ),
          );
      context.pop();
    }
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }
}
