class GetLocationsRequestDto {
  double latitude;
  double longitude;

  GetLocationsRequestDto(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Map<String, String> toQuery() {
    return {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }
}

class LocationDto {
  double latitude;
  double longitude;

  LocationDto(this.latitude, this.longitude);

  factory LocationDto.fromJson(dynamic dto) {
    return LocationDto(
      dto['latitude'] as double,
      dto['longitude'] as double,
    );
  }
}

enum CrowdStatus { good, ok, bad }

CrowdStatus resolveCrowdStatus(String status) {
  if (status == 'good') return CrowdStatus.good;
  if (status == 'ok') return CrowdStatus.ok;
  return CrowdStatus.bad;
}

class GetLocationsResponseDto {
  CrowdStatus status;
  List<LocationDto> locations;

  GetLocationsResponseDto(this.status, this.locations);

  factory GetLocationsResponseDto.fromJson(dynamic dto) {
    final locations = dto['locations']
        .map<LocationDto>((l) => LocationDto.fromJson(l))
        .toList();
    return GetLocationsResponseDto(
      resolveCrowdStatus(dto['status'] as String),
      locations as List<LocationDto>,
    );
  }
}
