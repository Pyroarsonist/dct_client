import 'package:dct_client/profile/enums/sex_enum.dart';

class UpdateProfileDto {
  final String name;
  final String birthDate;
  final Sex sex;

  UpdateProfileDto(this.name, this.birthDate, this.sex);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'sex': sex.name
    };
  }
}
