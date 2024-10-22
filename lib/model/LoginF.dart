class Loginf {
  String userType;
  String email;
  String password;

  Loginf({required this.userType, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'email': email,
      'password': password,
    };
  }

}