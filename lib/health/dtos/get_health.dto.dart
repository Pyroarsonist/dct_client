import '../enums/health_status_enum.dart';

class GetHealthDto {
  final HealthStatus status;

  GetHealthDto(this.status);

  static HealthStatus resolveHealthStatus(String status) {
    switch (status) {
      case 'infected':
        return HealthStatus.infected;
      case 'recovered':
        return HealthStatus.recovered;
      case 'vaccinated':
        return HealthStatus.vaccinated;
      default:
        return HealthStatus.unknown;
    }
  }

  factory GetHealthDto.fromJson(dynamic dto) {
    return GetHealthDto(
      resolveHealthStatus(dto['status'] as String),
    );
  }
}
