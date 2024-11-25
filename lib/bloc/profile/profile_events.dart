import 'package:social_feed_app/data/entities/user.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String username;
  LoadProfile(this.username);
}

class UpdateProfile extends ProfileEvent {
  final User user;
  UpdateProfile(this.user);
}
