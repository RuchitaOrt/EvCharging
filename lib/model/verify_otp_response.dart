class VerifyOtpResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;
  final bool? isNewUser;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isNewUser,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic>? json) {
    return VerifyOtpResponse(
      success: json?['success'] ?? false,
      message: json?['message'] ?? "",
      accessToken: json?['accessToken'],
      refreshToken: json?['refreshToken'],
      user: json?['user'] != null
          ? UserData.fromJson(json?['user'])
          : null,
      isNewUser: json?['isNewUser'],
    );
  }
}

class UserData {
  final String? userId;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? userRole;
  final bool? profileCompleted;

  UserData({
    this.userId,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.userRole,
    this.profileCompleted,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) {
    return UserData(
      userId: json?['userId'],
      phoneNumber: json?['phoneNumber'],
      firstName: json?['firstName'],
      lastName: json?['lastName'],
      email: json?['email'],
      userRole: json?['userRole'],
      profileCompleted: json?['profileCompleted'],
    );
  }
}
