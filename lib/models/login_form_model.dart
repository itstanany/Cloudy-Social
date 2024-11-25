class LoginFormModel {
  final String username;
  final String password;

  LoginFormModel({
    required this.username,
    required this.password,
  });

  bool isValid() {
    return username.isNotEmpty && password.isNotEmpty;
  }
}
