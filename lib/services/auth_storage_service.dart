import 'package:hive_flutter/hive_flutter.dart';

class AuthStorageService {
  static const String authBoxName = 'auth_box';
  static const String authKey = 'auth_state';

  Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(authBoxName);
  }

  Future<void> saveAuthState(String username) async {
    final box = Hive.box(authBoxName);
    await box.put(authKey, {
      'username': username,
      'isAuthenticated': true,
    });
  }

  Future<void> clearAuthState() async {
    final box = Hive.box(authBoxName);
    await box.delete(authKey);
  }

  bool isUserAuthenticated() {
    final box = Hive.box(authBoxName);
    final authData = box.get(authKey);
    return authData != null && authData['isAuthenticated'] == true;
  }

  String? getAuthenticatedUsername() {
    final box = Hive.box(authBoxName);
    final authData = box.get(authKey);
    return authData?['username'];
  }
}
