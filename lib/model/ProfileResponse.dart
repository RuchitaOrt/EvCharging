class ProfileResponse {
  final bool success;
  final String message;
  final UserProfile? user;

  ProfileResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null
          ? UserProfile.fromJson(json['user'])
          : null,
    );
  }
}
class UserProfile {
  final String recId;
  final String firstName;
  final String lastName;
  final String email;
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
  final DateTime? createdOn;

  UserProfile({
    required this.recId,
    required this.firstName,
    required this.lastName,
    required this.email,
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
    this.createdOn,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      recId: json['recId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['eMailID'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
      profileImageID: json['profileImageID'], // nullable
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      addressLine3: json['addressLine3'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
      profileCompleted: json['profileCompleted'] ?? 'No',
      userRole: json['userRole'] ?? '',
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
    );
  }
}
