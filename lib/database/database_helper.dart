import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/hole.dart';

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
      version: 1,
      onCreate: _createDB,
    );
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

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/images/courses.json');
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

  // Add this method to insert a new course
  Future<int> insertCourse(Course course) async {
    final db = await database;
    return await db.insert('courses', course.toMap());
  }

  // Add this method to insert holes for a course
  Future<void> insertHoles(List<Hole> holes) async {
    final db = await database;
    final batch = db.batch();
    
    for (var hole in holes) {
      batch.insert('holes', hole.toMap());
    }
    
    await batch.commit(noResult: true);
  }

  // Add this method to insert a course with its holes in a transaction
  Future<int> insertCourseWithHoles(Course course, List<Hole> holes) async {
    final db = await database;
    
    return await db.transaction((txn) async {
      // Insert the course
      final courseId = await txn.insert('courses', course.toMap());
      
      // Insert all holes with the new courseId
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
}