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

  factory LocationDto.fromJson(Map<String, dynamic> dto) {
    return LocationDto(
      dto['latitude'] as double,
      dto['longitude'] as double,
    );
  }
}

class GetLocationsResponseDto {
  String status;
  List<LocationDto> locations;

  GetLocationsResponseDto(this.status, this.locations);

  factory GetLocationsResponseDto.fromJson(Map<String, dynamic> dto) {
    var locations = dto['locations']
        .map<LocationDto>((l) => LocationDto.fromJson(l))
        .toList();
    return GetLocationsResponseDto(
      dto['status'] as String,
      locations as List<LocationDto>,
    );
  }
}
