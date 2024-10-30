class User {
    String email;
    String password;
    String UserType;

  User({
    required this.email,
    required this.password,
      required this.UserType,
});

  Map<String, dynamic> toJson() {
    return {
     
      'email': email,
      'password': password,
      'UserType': UserType,
    };
  }

}