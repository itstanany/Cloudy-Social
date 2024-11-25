class SignupFormModel {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  SignupFormModel({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  bool isValid() {
    return username.isNotEmpty &&
        password.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        dateOfBirth != null;
  }

  String getFormattedDate() {
    return '${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}';
  }
}
