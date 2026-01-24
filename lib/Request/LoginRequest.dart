class LoginRequest {
  final String emailOrPhone;
  final String password;

  LoginRequest({required this.emailOrPhone, required this.password});

  Map<String, dynamic> toJson() {
    return {
      "emailOrPhone": emailOrPhone,
      "password": password,
    };
  }
}
