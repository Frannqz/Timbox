//Register and Login
bool isValidEmail(String email) {
  return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
}

bool isValidRFC(String rfc) {
  return RegExp(r'^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$').hasMatch(rfc);
}

//Add collaborators
bool isValidCURP(String curp) {
  return RegExp(r'^[A-Z]{4}\d{6}[HM][A-Z]{5}\d{2}$').hasMatch(curp);
}

bool isValidNSS(String nss) {
  return RegExp(r'^\d{11}$').hasMatch(nss);
}

bool isValidSalario(String salario) {
  return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(salario);
}
