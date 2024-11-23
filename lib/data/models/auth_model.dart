import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class AuthState extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final bool isAuthenticated;

  AuthState({
    required this.username,
    required this.isAuthenticated,
  });
}
