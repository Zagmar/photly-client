abstract class AuthCredentialsModel {
  final String email;
  final String password;

  AuthCredentialsModel({
    required this.email,
    required this.password
  });
}

class LoginCredential extends AuthCredentialsModel {
  LoginCredential({
    required String email,
    required String password
  }) : super(email: email, password: password);
}

class RegisterCredential extends AuthCredentialsModel {
  final String username;
  final DateTime anniversary;
  String? coupleCode;

  RegisterCredential({
    required String email,
    required String password,
    required this.username,
    required this.anniversary,
    this.coupleCode
  }) : super(email: email, password: password);
}