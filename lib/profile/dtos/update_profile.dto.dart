class UpdateProfileDto {
  final String name;
  final String birthDate;

  UpdateProfileDto(this.name, this.birthDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
    };
  }
}
