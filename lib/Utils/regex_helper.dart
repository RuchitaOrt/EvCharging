class RegexHelper {
  final String locationRegex = r'^[a-zA-Z0-9, /]*$';
  final String textAndSpaceRegex = r'^[a-zA-Z ]*$';
  final String integerRegex = r'^-?\d+$';
  final String emailRegex = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  final String textNumericWithSpaceAndHyphenRegex = r'[a-zA-Z0-9\s-]';
  final String alphanumericRegex = r'^[a-zA-Z0-9 ';
  final String basicRegex = r'^[a-zA-Z0-9 \.,@\|+\-%]*$';

  final String panCardRegex = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';

  final String addressRegex = r"[a-zA-Z0-9.,\-\/& ']";
  final String numberOnlyRegex = r'[0-9]';
  final String commissionPercentageRegex = r'^(100|[1-9]?[0-9])$';
  final String emailRegexForTextfield = r'[a-zA-Z0-9._@-]';
  final String basicWithoutEscaping = r'[a-zA-Z0-9.,@\\% ]';
  final String alphaNumericWithoutEscaping = r'[a-zA-Z0-9 ]';
  final String alphaNumericWithCommaWithoutEscaping = r'[a-zA-Z0-9, ]';
  final String panCardRegexForTextfield = r'^[a-zA-Z0-9]*';
  bool isLocationValid(String location) {
    return RegExp(locationRegex).hasMatch(location);
  }

  bool isNumbersOnly(String value) {
    return RegExp(integerRegex).hasMatch(value);
  }

  bool isEmailIdValid(String emailId) {
    return RegExp(emailRegex).hasMatch(emailId);
  }

  bool isBasicValid(String basic) {
    return RegExp(basicRegex).hasMatch(basic);
  }

  String alphanumericRegexWithOptionalComma(bool withComma) {
    return withComma ? alphanumericRegex + r',]*$' : alphanumericRegex + r']*$';
  }

  RegExp isAlphaNumericText({bool withComma = false}) {
    return RegExp(alphanumericRegexWithOptionalComma(withComma));
  }

  RegExp isValidLocation() {
    return RegExp(locationRegex);
  }

  RegExp isTextOnlyWithSpace() {
    return RegExp(textAndSpaceRegex);
  }

  RegExp isTextWithSpaceAndHyphen() {
    return RegExp(textNumericWithSpaceAndHyphenRegex);
  }

  RegExp isAddressRegex() {
    return RegExp(addressRegex);
  }

  bool isPanCardValid(String panCard) {
    return RegExp(panCardRegex).hasMatch(panCard);
  }
}
