import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/hole.dart';
import '../models/rounds.dart';
import '../models/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('discgolf.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
      CREATE TABLE rounds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseId INTEGER NOT NULL,
        courseName TEXT NOT NULL,
        coursePar INTEGER NOT NULL,
        date TEXT NOT NULL,
        totalScore INTEGER NOT NULL,
        scoreToPar INTEGER NOT NULL,
        birdies INTEGER NOT NULL,
        pars INTEGER NOT NULL,
        bogeys INTEGER NOT NULL,
        isPersonalBest INTEGER NOT NULL DEFAULT 0,
        holeScores TEXT,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');
  }
}

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        details TEXT NOT NULL,
        par TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        holes INTEGER NOT NULL,
        distance REAL NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE holes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseId INTEGER NOT NULL,
        holeNumber INTEGER NOT NULL,
        par INTEGER NOT NULL,
        distance REAL NOT NULL,
        elevation REAL NOT NULL,
        imagePath TEXT NOT NULL,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
    CREATE TABLE rounds (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      courseId INTEGER NOT NULL,
      courseName TEXT NOT NULL,
      coursePar INTEGER NOT NULL,
      date TEXT NOT NULL,
      totalScore INTEGER NOT NULL,
      scoreToPar INTEGER NOT NULL,
      eagles INTEGER NOT NULL,
      birdies INTEGER NOT NULL,
      pars INTEGER NOT NULL,
      bogeys INTEGER NOT NULL,
      isPersonalBest INTEGER NOT NULL DEFAULT 0,
      holeScores TEXT,
      FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE
    )
  ''');

    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT UNIQUE NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      fullName TEXT,
      avatarPath TEXT,
      createdAt TEXT NOT NULL
    )
  ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    try {
      final String jsonString = await rootBundle.loadString('lib/database/courses.json');
      final List<dynamic> coursesData = json.decode(jsonString);

      for (var courseData in coursesData) {
        final courseId = await db.insert('courses', {
          'name': courseData['name'],
          'details': courseData['details'],
          'par': courseData['par'],
          'imagePath': courseData['imagePath'],
          'holes': courseData['holes'],
          'distance': (courseData['distance'] as num).toDouble(),
          'latitude': (courseData['latitude'] as num).toDouble(),
          'longitude': (courseData['longitude'] as num).toDouble(),
        });

        final List<dynamic> holesList = courseData['holesList'] ?? [];
        for (var holeData in holesList) {
          await db.insert('holes', {
            'courseId': courseId,
            'holeNumber': holeData['holeNumber'],
            'par': holeData['par'],
            'distance': (holeData['distance'] as num).toDouble(),
            'elevation': (holeData['elevation'] as num).toDouble(),
            'imagePath': holeData['imagePath'],
          });
        }
      }
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  Future<List<Course>> getAllCourses() async {
    final db = await database;
    final result = await db.query('courses', orderBy: 'name ASC');
    return result.map((json) => Course.fromMap(json)).toList();
  }

  Future<Course?> getCourse(int id) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Course.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Hole>> getHolesByCourse(int courseId) async {
    final db = await database;
    final result = await db.query(
      'holes',
      where: 'courseId = ?',
      whereArgs: [courseId],
      orderBy: 'holeNumber ASC',
    );
    return result.map((json) => Hole.fromMap(json)).toList();
  }

  Future<Hole?> getHole(int courseId, int holeNumber) async {
    final db = await database;
    final maps = await db.query(
      'holes',
      where: 'courseId = ? AND holeNumber = ?',
      whereArgs: [courseId, holeNumber],
    );

    if (maps.isNotEmpty) {
      return Hole.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertCourse(Course course) async {
    final db = await database;
    return await db.insert('courses', course.toMap());
  }

  Future<void> insertHoles(List<Hole> holes) async {
    final db = await database;
    final batch = db.batch();
    
    for (var hole in holes) {
      batch.insert('holes', hole.toMap());
    }
    
    await batch.commit(noResult: true);
  }

  Future<int> insertCourseWithHoles(Course course, List<Hole> holes) async {
    final db = await database;
    
    return await db.transaction((txn) async {
      final courseId = await txn.insert('courses', course.toMap());
      
      for (var hole in holes) {
        await txn.insert('holes', {
          'courseId': courseId,
          'holeNumber': hole.holeNumber,
          'par': hole.par,
          'distance': hole.distance,
          'elevation': hole.elevation,
          'imagePath': hole.imagePath,
        });
      }
      
      return courseId;
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
  Future<int> saveRound(Round round) async {
  final db = await database;
  return await db.insert('rounds', round.toMap());
}

Future<List<Round>> getAllRounds() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'rounds',
    orderBy: 'date DESC',
  );
  return List.generate(maps.length, (i) => Round.fromMap(maps[i]));
}

Future<List<Round>> getRoundsByCourse(int courseId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'rounds',
    where: 'courseId = ?',
    whereArgs: [courseId],
    orderBy: 'date DESC',
  );
  return List.generate(maps.length, (i) => Round.fromMap(maps[i]));
}

Future<Round?> getBestRoundForCourse(int courseId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'rounds',
    where: 'courseId = ?',
    whereArgs: [courseId],
    orderBy: 'totalScore ASC',
    limit: 1,
  );
  if (maps.isEmpty) return null;
  return Round.fromMap(maps[0]);
}

Future<int> deleteRound(int id) async {
  final db = await database;
  return await db.delete(
    'rounds',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> updatePersonalBests(int courseId) async {
  final db = await database;
  
  // First, remove personal best flag from all rounds for this course
  await db.update(
    'rounds',
    {'isPersonalBest': 0},
    where: 'courseId = ?',
    whereArgs: [courseId],
  );
  
  // Then, find and mark the best round
  final bestRound = await getBestRoundForCourse(courseId);
  if (bestRound != null && bestRound.id != null) {
    await db.update(
      'rounds',
      {'isPersonalBest': 1},
      where: 'id = ?',
      whereArgs: [bestRound.id],
    );
  }
}
  Future<Map<String, Round>> getPersonalBestsForAllCourses() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT r.* FROM rounds r
    INNER JOIN (
      SELECT courseId, MIN(totalScore) as bestScore
      FROM rounds
      GROUP BY courseId
    ) best ON r.courseId = best.courseId AND r.totalScore = best.bestScore
  ''');

  Map<String, Round> personalBests = {};
  for (var map in maps) {
    final round = Round.fromMap(map);
    personalBests[round.courseName] = round;
  }
  
  return personalBests;
}

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Register new user
  Future<int?> registerUser(User user) async {
    final db = await database;
    
    try {
      // Check if username already exists
      final existingUsername = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [user.username],
      );
      
      if (existingUsername.isNotEmpty) {
        throw Exception('Username already exists');
      }
      
      // Check if email already exists
      final existingEmail = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [user.email],
      );
      
      if (existingEmail.isNotEmpty) {
        throw Exception('Email already exists');
      }
      
      // Hash password and insert user
      final hashedUser = user.copyWith(
        password: _hashPassword(user.password),
      );
      
      return await db.insert('users', hashedUser.toMap());
    } catch (e) {
      print('Error registering user: $e');
      rethrow;
    }
  }

  // Login user
  Future<User?> loginUser(String usernameOrEmail, String password) async {
    final db = await database;
    
    try {
      final hashedPassword = _hashPassword(password);
      
      // Try to find user by username or email
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: '(username = ? OR email = ?) AND password = ?',
        whereArgs: [usernameOrEmail, usernameOrEmail, hashedPassword],
      );
      
      if (maps.isEmpty) {
        return null;
      }
      
      return User.fromMap(maps.first);
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // Get user by ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  // Update user profile
  Future<int> updateUser(User user) async {
    final db = await database;
    
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Update password
  Future<int> updatePassword(int userId, String oldPassword, String newPassword) async {
    final db = await database;
    
    // Verify old password
    final user = await getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }
    
    if (user.password != _hashPassword(oldPassword)) {
      throw Exception('Incorrect password');
    }
    
    // Update with new password
    return await db.update(
      'users',
      {'password': _hashPassword(newPassword)},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}