abstract class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  SignupSubmitted({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });
}
