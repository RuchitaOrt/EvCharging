class AppError {
  final _message;
  final _prefix;

  AppError([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataError extends AppError {
  FetchDataError([String? message])
      : super(message, "Error During Communication: ");
}

class MessageError extends AppError {
  MessageError([message]) : super(message, "");
}

class BadRequestError extends AppError {
  BadRequestError([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedError extends AppError {
  UnauthorisedError([message]) : super(message, "Unauthorised: ");
}

class InvalidInputError extends AppError {
  InvalidInputError([String? message]) : super(message, "Invalid Input: ");
}
