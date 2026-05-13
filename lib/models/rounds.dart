class Round {
  final int? id;
  final String courseName;
  final int courseId;
  final int totalScore;
  final int coursePar;
  final int scoreToPar;
  final int eagles;
  final int birdies;
  final int pars;
  final int bogeys;
  final DateTime date;
  final bool isPersonalBest;
  final Map<int, int>? holeScores; // holeNumber -> score

  Round({
    this.id,
    required this.courseName,
    required this.courseId,
    required this.totalScore,
    required this.coursePar,
    required this.scoreToPar,
    required this.eagles,
    required this.birdies,
    required this.pars,
    required this.bogeys,
    required this.date,
    this.isPersonalBest = false,
    this.holeScores,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'courseId': courseId,
      'totalScore': totalScore,
      'coursePar': coursePar,
      'scoreToPar': scoreToPar,
      'eagles': eagles,
      'birdies': birdies,
      'pars': pars,
      'bogeys': bogeys,
      'date': date.toIso8601String(),
      'isPersonalBest': isPersonalBest ? 1 : 0,
      'holeScores': holeScores != null ? _encodeHoleScores(holeScores!) : null,
    };
  }

  factory Round.fromMap(Map<String, dynamic> map) {
    return Round(
      id: map['id'] as int?,
      courseName: map['courseName'] as String,
      courseId: map['courseId'] as int,
      totalScore: map['totalScore'] as int,
      coursePar: map['coursePar'] as int,
      scoreToPar: map['scoreToPar'] as int,
      eagles: map['eagles'] as int,
      birdies: map['birdies'] as int,
      pars: map['pars'] as int,
      bogeys: map['bogeys'] as int,
      date: DateTime.parse(map['date'] as String),
      isPersonalBest: (map['isPersonalBest'] as int) == 1,
      holeScores: map['holeScores'] != null 
          ? _decodeHoleScores(map['holeScores'] as String)
          : null,
    );
  }

  static String _encodeHoleScores(Map<int, int> scores) {
    return scores.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  static Map<int, int> _decodeHoleScores(String encoded) {
    final Map<int, int> scores = {};
    for (final pair in encoded.split(',')) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        scores[int.parse(parts[0])] = int.parse(parts[1]);
      }
    }
    return scores;
  }

  Round copyWith({
    int? id,
    String? courseName,
    int? courseId,
    int? totalScore,
    int? coursePar,
    int? scoreToPar,
    int? eagles,
    int? birdies,
    int? pars,
    int? bogeys,
    DateTime? date,
    bool? isPersonalBest,
    Map<int, int>? holeScores,
  }) {
    return Round(
      id: id ?? this.id,
      courseName: courseName ?? this.courseName,
      courseId: courseId ?? this.courseId,
      totalScore: totalScore ?? this.totalScore,
      coursePar: coursePar ?? this.coursePar,
      scoreToPar: scoreToPar ?? this.scoreToPar,
      eagles: eagles ?? this.eagles,
      birdies: birdies ?? this.birdies,
      pars: pars ?? this.pars,
      bogeys: bogeys ?? this.bogeys,
      date: date ?? this.date,
      isPersonalBest: isPersonalBest ?? this.isPersonalBest,
      holeScores: holeScores ?? this.holeScores,
    );
  }
}