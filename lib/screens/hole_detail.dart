import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discpro/screens/fullscreen_image_viewer.dart';
import 'package:discpro/screens/scorecard.dart';
import 'package:discpro/database/database_helper.dart';
import 'package:discpro/models/hole.dart';
import 'package:discpro/models/course.dart';
import 'package:discpro/widgets/bottom_navbar.dart';


class HoleDetailPage extends StatefulWidget {
  final int courseId;
  final int holeNumber;

  const HoleDetailPage({
    Key? key,
    required this.courseId,
    required this.holeNumber,
  }) : super(key: key);

  @override
  State<HoleDetailPage> createState() => _HoleDetailPageState();
}

class _HoleDetailPageState extends State<HoleDetailPage> {
  Hole? _hole;
  Course? _course;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHoleData();
  }

  Future<void> _loadHoleData() async {
    try {
      final hole = await DatabaseHelper.instance.getHole(
        widget.courseId,
        widget.holeNumber,
      );
      final course = await DatabaseHelper.instance.getCourse(widget.courseId);

      setState(() {
        _hole = hole;
        _course = course;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading hole data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundDark = Color(0xFF121212);
    const Color primaryColor = Color(0xFF76F316);

    if (_isLoading) {
      return Theme(
        data: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme),
        ),
        child: const Scaffold(
          backgroundColor: backgroundDark,
          body: Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
        ),
      );
    }

    if (_hole == null || _course == null) {
      return Theme(
        data: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme),
        ),
        child: Scaffold(
          backgroundColor: backgroundDark,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hole not found',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme),
      ),
      child: Scaffold(
        backgroundColor: backgroundDark,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(
                          imagePath: _hole!.imagePath,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _hole!.imagePath,
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

              Column(
                children: [
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

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Container(
                      width: double.infinity,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'HOLE ${_hole!.holeNumber}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w900,
                                        height: 1.11,
                                        letterSpacing: -1.80,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _course!.name,
                                      style: const TextStyle(
                                        color: Color(0xFFA0A0A0),
                                        fontSize: 14,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w500,
                                        height: 1.43,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'PAR ${_hole!.par}',
                                style: const TextStyle(
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
                          _statPill(
                            label: 'DISTANCE',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${_hole!.distance} M',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '/ ${(_hole!.distance * 3.28084).round()} ft',
                                  style: const TextStyle(
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
                          _statPill(
                            label: 'ELEVATION',
                            child: Text(
                              '${_hole!.elevation >= 0 ? '+' : ''}${_hole!.elevation} M',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActiveScorecardPage(
                                    courseId: widget.courseId,
                                    startingHole: widget.holeNumber,
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.white.withOpacity(0.10),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA0A0A0),
              fontSize: 12,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              letterSpacing: 1.20,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return const BottomNavBar(
      activeItem: 'EXPLORE',
      showAddButton: false,
    );
}
}