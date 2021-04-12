class SendGeoDataDto {
  double latitude;
  double longitude;

  SendGeoDataDto(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
