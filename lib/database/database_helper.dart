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
    _database = await _initDB('discpro.db');
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

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE courses (
        id $idType,
        name $textType,
        details $textType,
        par $textType,
        imagePath $textType,
        holes $integerType,
        distance $realType,
        latitude $realType,
        longitude $realType
      )
    ''');

    await db.execute('''
      CREATE TABLE holes (
        id $idType,
        courseId $integerType,
        holeNumber $integerType,
        par $integerType,
        distance $realType,
        elevation $realType,
        imagePath $textType,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE
      )
    ''');

    // Insert initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insert courses
    final courses = [
      {
        'name': 'Karujärve Disc Golf Park',
        'details': '24 holes • 5.2 km',
        'par': 'Par: 77',
        'imagePath': 'assets/images/Karujärve/karujarve_full.webp',
        'holes': 24,
        'distance': 5.2,
        'latitude': 58.3780,
        'longitude': 22.5090,
      },
      {
        'name': 'Kudjape Course',
        'details': '12 holes • 3.8 km',
        'par': 'Par: 42',
        'imagePath': 'assets/images/Kudjape/kudjape_full.webp',
        'holes': 12,
        'distance': 3.8,
        'latitude': 58.3500,
        'longitude': 22.4800,
      },
      {
        'name': 'Mändjala Park',
        'details': '15 holes • 4.5 km',
        'par': 'Par: 30',
        'imagePath': 'assets/images/Mändjala/mandjala_full.webp',
        'holes': 15,
        'distance': 4.5,
        'latitude': 58.3200,
        'longitude': 22.5500,
      },
      {
        'name': 'Salme Disc Golf Course',
        'details': '18 holes • 2.1 km',
        'par': 'Par: 57',
        'imagePath': 'assets/images/Salme/salme_full.webp',
        'holes': 18,
        'distance': 2.1,
        'latitude': 58.1500,
        'longitude': 22.5200,
      },
      {
        'name': 'Pöide Disc Golf Course',
        'details': '21 holes • 1.9 km',
        'par': 'Par: 66',
        'imagePath': 'assets/images/Pöide/poide_scene.webp',
        'holes': 21,
        'distance': 1.9,
        'latitude': 58.4800,
        'longitude': 22.6500,
      },
      {
        'name': 'Musumännik Course',
        'details': '18 holes • 2.5 km',
        'par': 'Par: 55',
        'imagePath': 'assets/images/Musumännik/musumannik_full.webp',
        'holes': 18,
        'distance': 2.5,
        'latitude': 58.4200,
        'longitude': 22.5800,
      },
    ];

    for (var course in courses) {
      await db.insert('courses', course);
    }

    // Insert sample holes for Karujärve (courseId: 1)
    final holes = [
      {
        'courseId': 1,
        'holeNumber': 1,
        'par': 3,
        'distance': 85.0,
        'elevation': 3.0,
        'imagePath': 'assets/images/Karujärve/karujarve_1.webp',
      },
      
      // Add more holes as needed for each course
    ];

    for (var hole in holes) {
      await db.insert('holes', hole);
    }
  }

  // Course CRUD operations
  Future<Course> createCourse(Course course) async {
    final db = await instance.database;
    final id = await db.insert('courses', course.toMap());
    return course.copyWith(id: id);
  }

  Future<List<Course>> getAllCourses() async {
    final db = await instance.database;
    final result = await db.query('courses', orderBy: 'name ASC');
    return result.map((json) => Course.fromMap(json)).toList();
  }

  Future<Course?> getCourse(int id) async {
    final db = await instance.database;
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

  // Hole CRUD operations
  Future<List<Hole>> getHolesByCourse(int courseId) async {
    final db = await instance.database;
    final result = await db.query(
      'holes',
      where: 'courseId = ?',
      whereArgs: [courseId],
      orderBy: 'holeNumber ASC',
    );
    return result.map((json) => Hole.fromMap(json)).toList();
  }

  Future<Hole?> getHole(int courseId, int holeNumber) async {
    final db = await instance.database;
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

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}