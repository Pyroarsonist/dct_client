class GetProfileDto {
  String email;
  String name;
  DateTime birthDate;

  GetProfileDto(this.email, this.name, this.birthDate);

  factory GetProfileDto.fromJson(dynamic dto) {
    return GetProfileDto(
      dto['email'] as String,
      dto['name'] as String,
      DateTime.parse(dto['birthDate'] as String),
    );
  }
}
