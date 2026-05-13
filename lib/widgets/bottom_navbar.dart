import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6BF906);
const Color backgroundDark = Color(0xFF121212);

class BottomNavBar extends StatelessWidget {
  final String? activeItem;
  final bool showAddButton;

  const BottomNavBar({
    super.key,
    this.activeItem,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: backgroundDark,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.10))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _navItem(context, Icons.explore_outlined, 'EXPLORE', isSelected: activeItem == 'EXPLORE'),
                  _navItem(context, Icons.bar_chart_outlined, 'STATS', isSelected: activeItem == 'STATS'),
                  if (showAddButton) const SizedBox(width: 56),
                  _navItem(context, Icons.history_outlined, 'ROUNDS', isSelected: activeItem == 'ROUNDS'),
                  _navItem(context, Icons.person_outline, 'PROFILE', isSelected: activeItem == 'PROFILE'),
                ],
              ),
            ),
          ),
          if (showAddButton)
            Positioned(
              top: -28,
              child: GestureDetector(
                onTap: () {
                  print('Add button tapped!'); // Debug print
                  Navigator.pushNamed(context, '/add_course');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.35),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                            spreadRadius: -2,
                          ),
                          BoxShadow(
                            color: primaryColor.withOpacity(0.20),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add, color: Colors.black, size: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ADD A COURSE',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, {bool isSelected = false}) {
    final color = isSelected ? primaryColor : Colors.white60;
    return GestureDetector(
      onTap: () {
        // Don't navigate if already on the current page
        if (isSelected) return;
        
        switch (label) {
          case 'EXPLORE':
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 'STATS':
            Navigator.pushReplacementNamed(context, '/statistics');
            break;
          case 'ROUNDS':
            Navigator.pushNamed(context, '/rounds_history');
            break;
          case 'PROFILE':
            // Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}