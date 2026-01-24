class RegistrationResponse {
  final bool success;
  final String message;
  final UserModel? user;

  RegistrationResponse({
    required this.success,
    required this.message,
    this.user,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }
}
class UserModel {
  final String? recId;
  final String? firstName;
  final String? lastName;
  final String? eMailID;
  final String? phoneNumber;
  final String? countryCode;
  final String? profileImageID;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String? state;
  final String? city;
  final String? pinCode;
  final String? profileCompleted;
  final String? userRole;
  final DateTime? createdOn;

  UserModel({
    this.recId,
    this.firstName,
    this.lastName,
    this.eMailID,
    this.phoneNumber,
    this.countryCode,
    this.profileImageID,
    this.addressLine1,
    this.addressLine2,
    this.addressLine3,
    this.state,
    this.city,
    this.pinCode,
    this.profileCompleted,
    this.userRole,
    this.createdOn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      recId: json['recId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      eMailID: json['eMailID'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      profileImageID: json['profileImageID'], // null-safe
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      addressLine3: json['addressLine3'],
      state: json['state'],
      city: json['city'],
      pinCode: json['pinCode'],
      profileCompleted: json['profileCompleted'],
      userRole: json['userRole'],
      createdOn: json['createdOn'] != null
          ? DateTime.tryParse(json['createdOn'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recId': recId,
      'firstName': firstName,
      'lastName': lastName,
      'eMailID': eMailID,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'profileImageID': profileImageID,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'addressLine3': addressLine3,
      'state': state,
      'city': city,
      'pinCode': pinCode,
      'profileCompleted': profileCompleted,
      'userRole': userRole,
      'createdOn': createdOn?.toIso8601String(),
    };
  }
}
