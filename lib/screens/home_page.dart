import 'package:flutter/material.dart';

// Custom Colors
const Color primaryColor = Color(0xFF94F906);
const Color backgroundDark = Color(0xFF1B230F);
const Color surfaceDark = Color(0xFF121212);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Above the Nav bar
        child: FloatingActionButton.extended(
          backgroundColor: surfaceDark.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          onPressed: () {},
          icon: const Icon(Icons.map, color: primaryColor),
          label: const Text("Map View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar & Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Discover", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            _iconButton(Icons.notifications_outlined),
                            const SizedBox(width: 12),
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: primaryColor,
                              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search courses...",
                              prefixIcon: const Icon(Icons.search, color: primaryColor),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: primaryColor)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.filter_list, color: surfaceDark),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ... other slivers for content
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: surfaceDark.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomNavItem(Icons.home, "Home", isSelected: true),
          _bottomNavItem(Icons.leaderboard, "Rounds"),
          _bottomNavItem(Icons.add_circle_outline, "New Round"),
          _bottomNavItem(Icons.bar_chart, "Stats"),
          _bottomNavItem(Icons.person, "Profile"),
        ],
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, String text, {bool isSelected = false}) {
    final Color textCol = isSelected ? primaryColor : Colors.grey;
    final Color iconCol = isSelected ? primaryColor : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconCol, size: 24),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(color: textCol, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}