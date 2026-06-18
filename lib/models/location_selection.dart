class LocationSelection {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  const LocationSelection({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => name.trim().isEmpty ? 'Selected Location' : name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
