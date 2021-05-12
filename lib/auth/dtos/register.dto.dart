import 'package:dct_client/profile/enums/sex_enum.dart';

class RegisterDto {
  String name;
  String email;
  String password;
  String birthDate;
  Sex sex;

  RegisterDto(this.name, this.email, this.password, this.birthDate, this.sex);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthDate': birthDate,
      'sex': sex.name,
    };
  }
}
