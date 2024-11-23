import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_bloc.dart';
import 'package:social_feed_app/bloc/auth/auth_events.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Add logout logic here
              context.read<AuthBloc>().add(
                    SignOutRequested(),
                  );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://picsum.photos/200',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _buildProfileItem(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'john.doe@example.com',
            ),
            _buildProfileItem(
              icon: Icons.location_on,
              title: 'Location',
              subtitle: 'New York, USA',
            ),
            _buildProfileItem(
              icon: Icons.calendar_today,
              title: 'Joined',
              subtitle: 'January 2024',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Add edit profile logic
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
