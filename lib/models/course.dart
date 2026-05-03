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

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int?,
      name: map['name'] as String,
      details: map['details'] as String,
      par: map['par'] as String,
      imagePath: map['imagePath'] as String,
      holes: map['holes'] as int,
      distance: (map['distance'] as num).toDouble(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
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
}