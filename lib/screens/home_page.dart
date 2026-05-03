
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discpro/widgets/bottom_navbar.dart';
import 'package:discpro/database/database_helper.dart';
import 'package:discpro/models/course.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Custom Colors matching your design
  static const Color primaryColor = Color(0xFF94F906);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await DatabaseHelper.instance.getAllCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading courses: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme),
      ),
      child: Scaffold(
        backgroundColor: backgroundDark,
        body: SafeArea(
          child: Stack(
            children: [
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadCourses,
                      color: primaryColor,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Bar
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Discover',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      _iconButton(Icons.notifications_outlined),
                                      const SizedBox(width: 12),
                                      _buildAvatar(),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Search Bar
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: _buildSearchBar(),
                            ),

                            const SizedBox(height: 24),

                            // Filters  
                            SizedBox(
                              height: 50,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                children: [
                                  _filterChip('All', isSelected: true),
                                  _filterChip('Nearby'),
                                  _filterChip('Popular'),
                                  _filterChip('Favorites'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Featured Section
                            _sectionHeader('Featured Courses'),
                            const SizedBox(height: 16),
                            _courses.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(Icons.golf_course, size: 64, color: Colors.white.withOpacity(0.3)),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No courses yet',
                                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Add your first course to get started!',
                                            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 280,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      itemCount: _courses.length,
                                      itemBuilder: (context, index) {
                                        final course = _courses[index];
                                        return GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.pushNamed(
                                              context,
                                              '/hole_detail',
                                              arguments: {
                                                'courseId': course.id,
                                                'holeNumber': 1,
                                              },
                                            );
                                            // Refresh if returning from course detail
                                            if (result == true) {
                                              _loadCourses();
                                            }
                                          },
                                          child: _featuredCourseCard(
                                            course.name,
                                            '${course.holes} holes • ${course.distance.toStringAsFixed(1)} km',
                                            'Par: ${course.par}',
                                            course.imagePath,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                            const SizedBox(height: 32),

                            // Nearby Section
                            if (_courses.isNotEmpty) ...[
                              _sectionHeader('All Courses', showSeeAll: false),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _courses.length,
                                itemBuilder: (context, index) {
                                  final course = _courses[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        '/hole_detail',
                                        arguments: {
                                          'courseId': course.id,
                                          'holeNumber': 1,
                                        },
                                      );
                                      if (result == true) {
                                        _loadCourses();
                                      }
                                    },
                                    child: _nearbyCourseCard(
                                      course.name,
                                      '${course.holes} holes • ${course.distance.toStringAsFixed(1)} km',
                                      'Par: ${course.par}',
                                      course.imagePath,
                                    ),
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 120), // Padding for bottom nav
                          ],
                        ),
                      ),
                    ),

              // Bottom Nav
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const BottomNavBar(
                  activeItem: 'EXPLORE',
                  showAddButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
      child: const Center(
        child: Text('Q', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search courses...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {bool showSeeAll = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          if (showSeeAll)
            TextButton(
              onPressed: () {},
              child: const Text('See All', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: surfaceDark,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _filterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: surfaceDark,
        selectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(color: isSelected ? primaryColor : Colors.white10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  Widget _featuredCourseCard(String name, String details, String par, String imagePath) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white.withOpacity(0.05),
                    child: const Center(
                      child: Icon(Icons.landscape, size: 48, color: Colors.white24),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(details, style: const TextStyle(color: Colors.white60, fontSize: 14)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(par, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nearbyCourseCard(String name, String details, String rating, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.map_outlined, color: primaryColor, size: 24);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}