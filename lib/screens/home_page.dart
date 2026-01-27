import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Custom Colors matching your design
  static const Color primaryColor = Color(0xFF94F906);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

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
              SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final courses = [
                            {
                              'name': 'Karujärve Disc Golf Park',
                              'details': '18 holes • 5.2 km',
                              'rating': '4.8',
                              'image': 'assets/images/Karujärve/karujarve_full.webp',
                            },
                            {
                              'name': 'Kudjape Course',
                              'details': '12 holes • 3.8 km',
                              'rating': '4.6',
                              'image': 'assets/images/Kudjape/kudjape_full.webp',
                            },
                            {
                              'name': 'Mändjala Park',
                              'details': '15 holes • 4.5 km',
                              'rating': '4.9',
                              'image': 'assets/images/Mändjala/mandjala_full.webp',
                            },
                          ];
                          
                          final course = courses[index];
                          return _featuredCourseCard(
                            course['name']!,
                            course['details']!,
                            course['rating']!,
                            course['image']!,
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Nearby Section
                    _sectionHeader('Nearby Courses', showSeeAll: false),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _nearbyCourseCard(
                          'Pöide Disc Golf Course',
                          '2.3 km away • 9 holes',
                          '4.6',
                          
                        );
                      },
                    ),
                    const SizedBox(height: 120), // Padding for bottom nav
                  ],
                ),
              ),
              
              // FAB
              Positioned(
                right: 16,
                bottom: 110,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: surfaceDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: const BorderSide(color: primaryColor, width: 0.5),
                  ),
                  icon: const Icon(Icons.add_location_alt, color: primaryColor),
                  label: const Text('Add Course', style: TextStyle(color: Colors.white)),
                ),
              ),
              
              // Bottom Nav
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

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
      width: 40, height: 40,
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
          fontSize: 14, // Slightly larger font
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
        side: BorderSide(color: isSelected ? primaryColor : Colors.white10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  Widget _featuredCourseCard(String name, String details, String rating, String imagePath) {
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
                Text(name, 
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
                        Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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

  Widget _nearbyCourseCard(String name, String details, String rating) {
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
            child: const Icon(Icons.map_outlined, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

Widget _buildBottomNav() {
  return Container(
    height: 80, // Increased height slightly to fit text
    margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    decoration: BoxDecoration(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(100),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 10),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.explore, 'Explore', isSelected: true),
        _navItem(Icons.history, 'Rounds'),
        _navItem(Icons.map_outlined, 'Map'),
        _navItem(Icons.person_outline, 'Profile'),
      ],
    ),
  );
}

Widget _navItem(IconData icon, String label, {bool isSelected = false}) {
  return Column(
    mainAxisSize: MainAxisSize.min, // Keeps the column tight around the content
    children: [
      Icon(
        icon,
        color: isSelected ? primaryColor : Colors.white,
        size: 24,
      ),
      const SizedBox(height: 4), // Space between icon and text
      Text(
        label,
        style: TextStyle(
          color: isSelected ? primaryColor : Colors.white,
          fontSize: 10,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ],
  );
}
}