import 'package:crypt/crypt.dart';

class PasswordHasherService {
  static String hashPassword(String password) {
    return Crypt.sha256(password).toString();
  }

  static bool verifyPassword(String password, String hashedPassword) {
    return Crypt(hashedPassword).match(password);
  }
}
