class RegisterDto {
  String name;
  String email;
  String password;
  String birthDate;

  RegisterDto(this.name, this.email, this.password, this.birthDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthDate': birthDate,
    };
  }
}
