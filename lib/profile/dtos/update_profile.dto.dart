class UpdateProfileDto {
  String name;
  String birthDate;

  UpdateProfileDto(this.name, this.birthDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
    };
  }
}
