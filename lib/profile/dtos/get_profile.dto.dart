class GetProfileDto {
  final String email;
  final String name;
  final DateTime birthDate;

  GetProfileDto(this.email, this.name, this.birthDate);

  factory GetProfileDto.fromJson(dynamic dto) {
    return GetProfileDto(
      dto['email'] as String,
      dto['name'] as String,
      DateTime.parse(dto['birthDate'] as String),
    );
  }
}
