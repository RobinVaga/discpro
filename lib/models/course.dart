class Course {
  final int? id;
  final String name;
  final String details;
  final String par;
  final String imagePath;
  final int holes;
  final double distance;
  final double latitude;
  final double longitude;

  Course({
    this.id,
    required this.name,
    required this.details,
    required this.par,
    required this.imagePath,
    required this.holes,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'par': par,
      'imagePath': imagePath,
      'holes': holes,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      details: map['details'],
      par: map['par'],
      imagePath: map['imagePath'],
      holes: map['holes'],
      distance: map['distance'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}