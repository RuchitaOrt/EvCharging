class RegisterRequest {
  final String firstName;
  final String lastName;
  final String eMailID;
  final String phoneNumber;
  final String countryCode;
  final String password;
  final String confirmPassword;
  final String addressLine1;
  final String addressLine2;
  final String addressLine3;
  final String state;
  final String city;
  final String pinCode;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.eMailID,
    required this.phoneNumber,
    required this.countryCode,
    required this.password,
    required this.confirmPassword,
    required this.addressLine1,
    required this.addressLine2,
    required this.addressLine3,
    required this.state,
    required this.city,
    required this.pinCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "eMailID": eMailID,
      "phoneNumber": phoneNumber,
      "countryCode": countryCode,
      "password": password,
      "confirmPassword": confirmPassword,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "addressLine3": addressLine3,
      "state": state,
      "city": city,
      "pinCode": pinCode,
    };
  }
}
