import 'package:ev_charging_app/Utils/regex_helper.dart';

class ValidationHelper {
  ValidationHelper._(); // private constructor

  static bool isEmailValid(String email) {
    return RegexHelper().isEmailIdValid(email);
  }
 static bool isValidPhone(String email) {
    return RegexHelper().isPhoneValid(email);
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }


  // static bool isPasswordValid(String password) {
  //   return password.trim().isNotEmpty;
  // }
  // static bool isConfirmPassword(String password) {
  //   return password.trim().isNotEmpty;
  // }

  static bool isPanValid(String pan) {
    return RegexHelper().isPanCardValid(pan);
  }
static bool isPasswordValid(String password) {
  return password.trim().length >= 6;
}

static bool isConfirmPassword(String password) {
  return password.trim().length >= 6;
}

  static bool isAlphaNumeric(String value, {bool withComma = false}) {
    return RegexHelper().isAlphaNumericText(withComma: withComma).hasMatch(value);
  }
}
