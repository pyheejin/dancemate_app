bool isEmailValid(String value) {
  RegExp regExp = RegExp(
    r'^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );
  return regExp.hasMatch(value);
}

bool isPasswordValid(String value) {
  // 최소 8자, 최대 15자
  RegExp regExp = RegExp(
    r'^.{2,15}$',
  );
  return regExp.hasMatch(value);
}
