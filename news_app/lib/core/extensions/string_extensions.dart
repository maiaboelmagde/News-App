extension EmailValidator on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegExp.hasMatch(this);
  }

  String get extractNameFromEmail{
    return split('@')[0];
  }
}
