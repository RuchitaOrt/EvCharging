class RefreshTokenResponse {
  final bool success;
  final String message;
  final RefreshUser? user;

  RefreshTokenResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user:
          json['user'] != null ? RefreshUser.fromJson(json['user']) : null,
    );
  }
}

class RefreshUser {
  final String recId;
  final String firstName;
  final String lastName;
  final String eMailID;
  final String phoneNumber;
  final String countryCode;
  final String? profileImageID;
  final String addressLine1;
  final String addressLine2;
  final String addressLine3;
  final String state;
  final String city;
  final String pinCode;
  final String profileCompleted;
  final String userRole;
  final DateTime createdOn;

  RefreshUser({
    required this.recId,
    required this.firstName,
    required this.lastName,
    required this.eMailID,
    required this.phoneNumber,
    required this.countryCode,
    this.profileImageID,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.profileCompleted,
    required this.userRole,
    required this.createdOn,
  });

  factory RefreshUser.fromJson(Map<String, dynamic> json) {
    return RefreshUser(
      recId: json['recId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      eMailID: json['eMailID'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      profileImageID: json['profileImageID'],
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      addressLine3: json['addressLine3'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
      profileCompleted: json['profileCompleted'] ?? '',
      userRole: json['userRole'] ?? '',
      createdOn:
          DateTime.tryParse(json['createdOn'] ?? '') ?? DateTime.now(),
    );
  }
}
