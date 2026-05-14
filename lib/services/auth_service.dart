import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

class AuthService {
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';
  
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    
    if (isLoggedIn) {
      final userId = prefs.getInt(_userIdKey);
      if (userId != null) {
        _currentUser = await DatabaseHelper.instance.getUserById(userId);
      }
    }
  }

  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final user = User(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );
      
      final userId = await DatabaseHelper.instance.registerUser(user);
      
      if (userId == null) {
        throw Exception('Failed to register user');
      }
      
      final registeredUser = await DatabaseHelper.instance.getUserById(userId);
      
      if (registeredUser == null) {
        throw Exception('Failed to retrieve registered user');
      }
      
      await _saveSession(registeredUser);
      _currentUser = registeredUser;
      
      return registeredUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User> login(String usernameOrEmail, String password) async {
    try {
      final user = await DatabaseHelper.instance.loginUser(usernameOrEmail, password);
      
      if (user == null) {
        throw Exception('Invalid credentials');
      }
      
      await _saveSession(user);
      _currentUser = user;
      
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.setBool(_isLoggedInKey, false);
    _currentUser = null;
  }

  Future<User> updateProfile({
    String? fullName,
    String? email,
    String? avatarPath,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }
    
    final updatedUser = _currentUser!.copyWith(
      fullName: fullName ?? _currentUser!.fullName,
      email: email ?? _currentUser!.email,
      avatarPath: avatarPath ?? _currentUser!.avatarPath,
    );
    
    await DatabaseHelper.instance.updateUser(updatedUser);
    _currentUser = updatedUser;
    
    return updatedUser;
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }
    
    await DatabaseHelper.instance.updatePassword(
      _currentUser!.id!,
      oldPassword,
      newPassword,
    );
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, user.id!);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> refreshUser() async {
    if (_currentUser?.id != null) {
      _currentUser = await DatabaseHelper.instance.getUserById(_currentUser!.id!);
    }
  }
}