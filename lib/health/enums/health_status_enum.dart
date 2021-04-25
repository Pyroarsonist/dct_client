enum HealthStatus { unknown, infected, recovered, vaccinated }

extension HealthStatusExtenstion on HealthStatus {
  String get name {
    switch (this) {
      case HealthStatus.infected:
        return 'infected';
      case HealthStatus.recovered:
        return 'recovered';
      case HealthStatus.vaccinated:
        return 'vaccinated';
      default:
        return 'unknown';
    }
  }
}
