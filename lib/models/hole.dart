class Hole {
  final int? id;
  final int courseId;
  final int holeNumber;
  final int par;
  final double distance;
  final double elevation;
  final String imagePath;

  Hole({
    this.id,
    required this.courseId,
    required this.holeNumber,
    required this.par,
    required this.distance,
    required this.elevation,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'holeNumber': holeNumber,
      'par': par,
      'distance': distance,
      'elevation': elevation,
      'imagePath': imagePath,
    };
  }

  factory Hole.fromMap(Map<String, dynamic> map) {
    return Hole(
      id: map['id'],
      courseId: map['courseId'],
      holeNumber: map['holeNumber'],
      par: map['par'],
      distance: map['distance'],
      elevation: map['elevation'],
      imagePath: map['imagePath'],
    );
  }
}