class Hole {
  final int? id;
  final int? courseId;
  final int holeNumber;
  final int par;
  final double distance;
  final double elevation;
  final String imagePath;

  Hole({
    this.id,
    this.courseId,
    required this.holeNumber,
    required this.par,
    required this.distance,
    required this.elevation,
    required this.imagePath,
  });

  factory Hole.fromMap(Map<String, dynamic> map) {
    return Hole(
      id: map['id'] as int?,
      courseId: map['courseId'] as int?,
      holeNumber: map['holeNumber'] as int,
      par: map['par'] as int,
      distance: (map['distance'] as num).toDouble(),
      elevation: (map['elevation'] as num).toDouble(),
      imagePath: map['imagePath'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (courseId != null) 'courseId': courseId,
      'holeNumber': holeNumber,
      'par': par,
      'distance': distance,
      'elevation': elevation,
      'imagePath': imagePath,
    };
  }
}
