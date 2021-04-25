import '../enums/health_status_enum.dart';

class UpdateHealthDto {
  final HealthStatus status;

  UpdateHealthDto(this.status);

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
    };
  }
}
