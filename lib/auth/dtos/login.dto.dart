class LoginDto {
  String email;
  String password;

  LoginDto(this.email, this.password);

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
