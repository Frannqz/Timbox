bool isValidEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
}

bool isValidRFC(String rfc) {
  return RegExp(r'^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$').hasMatch(rfc);
}
