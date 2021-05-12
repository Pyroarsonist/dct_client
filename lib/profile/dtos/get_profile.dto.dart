import 'package:dct_client/profile/enums/sex_enum.dart';

class GetProfileDto {
  final String email;
  final String name;
  final DateTime birthDate;
  final Sex sex;


  GetProfileDto(this.email, this.name, this.birthDate, this.sex);

  static Sex resolveSex(String sex) {
    if (sex == 'female') return Sex.female;
    return Sex.male;
  }

  factory GetProfileDto.fromJson(dynamic dto) {
    return GetProfileDto(
      dto['email'] as String,
      dto['name'] as String,
      DateTime.parse(dto['birthDate'] as String),
      resolveSex(dto['sex'] as String)
    );
  }
}
