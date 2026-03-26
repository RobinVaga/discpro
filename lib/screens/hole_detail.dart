import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discpro/screens/fullscreen_image_viewer.dart';


class HoleDetailPage extends StatelessWidget {
  const HoleDetailPage({super.key});

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
              // ── Full-screen background image + gradient ──
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FullScreenImageViewer(
                          imagePath: 'assets/images/Karujärve/karujarve_1.webp',
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/Karujärve/karujarve_1.webp',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF1A1A1A),
                          child: const Center(
                            child: Text(
                              'Image not found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // ── Dark gradient overlay (bottom fade to backgroundDark) ──
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.35, 0.65, 1.0],
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                              backgroundDark.withOpacity(0.7),
                              backgroundDark,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              // ── Main scrollable content ──
              Column(
                children: [
                  // Top app bar
                  Container(
                    width: double.infinity,
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xCC121212),
                      border: Border(
                        bottom: BorderSide(color: Colors.white.withOpacity(0.10)),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2676F316),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'DISCPRO',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 20,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.10),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacer — pushes the card to the bottom half
                  const Spacer(),

                  // ── Info card ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      width: double.infinity, // ✅ 100% width like Tailwind w-full
                      padding: const EdgeInsets.all(24),
                      decoration: ShapeDecoration(
                        color: const Color(0xE51E1E1E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.white.withOpacity(0.10),
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 50,
                            offset: Offset(0, 25),
                            spreadRadius: -12,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hole header row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'HOLE 1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w900,
                                      height: 1.11,
                                      letterSpacing: -1.80,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Karujärve Disc Golf Park',
                                    style: TextStyle(
                                      color: Color(0xFFA0A0A0),
                                      fontSize: 14,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'PAR 3',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 25,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w900,
                                  height: 1.44,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Distance pill
                          _statPill(
                            label: 'DISTANCE',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: const [
                                Text(
                                  '85 M',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '/ 279 ft',
                                  style: TextStyle(
                                    color: Color(0xFFA0A0A0),
                                    fontSize: 12,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Elevation pill
                          _statPill(
                            label: 'ELEVATION',
                            child: const Text(
                              '+3 M',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Start Round button
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: ShapeDecoration(
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x6694F906),
                                  blurRadius: 24,
                                  offset: Offset(0, 0),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'START ROUND',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.80,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Space for bottom nav
                  const SizedBox(height: 80),
                ],
              ),

              // ── Bottom Nav ──
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

  Widget _statPill({required String label, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.white.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA0A0A0),
              fontSize: 10,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w900,
              height: 1.50,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
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
                  _navItem(Icons.explore_outlined, 'EXPLORE'),
                  _navItem(Icons.bar_chart_outlined, 'STATS'),
                  const SizedBox(width: 56),
                  _navItem(Icons.history_outlined, 'ROUNDS', isSelected: true),
                  _navItem(Icons.person_outline, 'PROFILE'),
                ],
              ),
            ),
          ),
          Positioned(
            top: -28,
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
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? primaryColor : Colors.white.withOpacity(0.50),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : Colors.white.withOpacity(0.50),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}