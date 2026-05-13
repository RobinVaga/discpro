import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discpro/models/course.dart';
import 'package:discpro/models/hole.dart';
import 'package:discpro/database/database_helper.dart';
import 'package:discpro/widgets/bottom_navbar.dart';
import 'package:discpro/screens/fullscreen_image_viewer.dart';
import 'package:discpro/screens/round_summary.dart';
import 'package:discpro/models/rounds.dart';
import 'dart:convert';

class ActiveScorecardPage extends StatefulWidget {
  final int courseId;
  final int startingHole;

  const ActiveScorecardPage({
    Key? key,
    required this.courseId,
    this.startingHole = 1,
  }) : super(key: key);

  @override
  State<ActiveScorecardPage> createState() => _ActiveScorecardPageState();
}

class _ActiveScorecardPageState extends State<ActiveScorecardPage> {
  Course? _course;
  List<Hole> _holes = [];
  bool _isLoading = true;
  late PageController _pageController;
  int _currentHole = 1;
  Map<int, int> _scores = {}; // holeNumber -> score

  @override
  void initState() {
    super.initState();
    _currentHole = widget.startingHole;
    _pageController = PageController(initialPage: widget.startingHole - 1);
    _loadCourseData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCourseData() async {
    try {
      final course = await DatabaseHelper.instance.getCourse(widget.courseId);
      final holes = await DatabaseHelper.instance.getHolesByCourse(widget.courseId);

      setState(() {
        _course = course;
        _holes = holes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading course data: $e')),
        );
      }
    }
  }

  void _updateScore(int holeNumber, int score) {
    setState(() {
      _scores[holeNumber] = score;
    });
  }

  int _getTotalScore() {
    return _scores.values.fold(0, (sum, score) => sum + score);
  }

  int _getTotalPar() {
    return _holes.fold(0, (sum, hole) => sum + hole.par);
  }

  int _getScoreToPar() {
    return _getTotalScore() - _getTotalPar();
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

  if (_course == null || _holes.isEmpty) {
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
                'Course not found',
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

  final currentHoleData = _holes[_currentHole - 1];

  return Theme(
    data: ThemeData.dark().copyWith(
      textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme),
    ),
    child: Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
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
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Hole Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'HOLE $_currentHole',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w900,
                          height: 1.11,
                          letterSpacing: -1.80,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildHoleNavigator(),
                      const SizedBox(height: 8),
                      Text(
                        '< SWIPE TO NAVIGATE HOLES >',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: ShapeDecoration(
                          color: const Color(0x1976F316),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0x3376F316),
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        child: Text(
                          'PAR ${currentHoleData.par} | ${currentHoleData.distance}M',
                          style: const TextStyle(
                            color: Color(0xFF76F316),
                            fontSize: 14,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                            letterSpacing: 1.40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scorecard
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _holes.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentHole = index + 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      final hole = _holes[index];
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 180), // Increased bottom padding
                        child: Column(
                          children: [
                            _buildHoleImage(hole),
                            _buildPlayerScorecard(hole),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Finish Round Button (above bottom nav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 80, // Position above bottom nav
              child: _buildFinishRoundButton(),
            ),

            // Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const BottomNavBar(
                activeItem: 'ROUNDS',
                showAddButton: false,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildHoleNavigator() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(7, (index) {
          final displayHole = _currentHole - 3 + index;
          if (displayHole < 1 || displayHole > _holes.length) {
            return const SizedBox(width: 48);
          }

          final isActive = displayHole == _currentHole;

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                displayHole - 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                _currentHole = displayHole;
              });
            },
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF76F316) : const Color(0xFF2A2A2A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF76F316)
                      : Colors.white.withOpacity(0.2),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  '$displayHole',
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.white,
                    fontSize: isActive ? 20 : 16,
                    fontFamily: 'Lexend',
                    fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPlayerScorecard(Hole hole) {
    const Color primaryColor = Color(0xFF76F316);
    final currentScore = _scores[hole.holeNumber] ?? 0;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PLAYER 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0x1976F316),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0x3376F316),
                        ),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    child: Text(
                      'TOTAL: ${_getTotalScore()}',
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Score input buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _scoreButton(hole.holeNumber, 1, 'ACE', currentScore),
              _scoreButton(hole.holeNumber, 2, '2', currentScore),
              _scoreButton(hole.holeNumber, 3, '3', currentScore),
              _scoreButton(hole.holeNumber, 4, '4', currentScore),
              _scoreButton(hole.holeNumber, 5, '5', currentScore),
              _scoreButton(hole.holeNumber, 6, '6+', currentScore),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Score relative to par
          if (currentScore > 0)
            Center(
              child: Text(
                _getScoreText(currentScore, hole.par),
                style: TextStyle(
                  color: _getScoreColor(currentScore, hole.par),
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _scoreButton(int holeNumber, int score, String label, int currentScore) {
    final isSelected = currentScore == score;
    const Color primaryColor = Color(0xFF76F316);

    return GestureDetector(
      onTap: () => _updateScore(holeNumber, score),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : const Color(0xFF2A2A2A),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 14,
              fontFamily: 'Lexend',
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  String _getScoreText(int score, int par) {
    final diff = score - par;
    if (diff == -2) return 'EAGLE! 🦅';
    if (diff == -1) return 'BIRDIE! 🐦';
    if (diff == 0) return 'PAR';
    if (diff == 1) return 'BOGEY';
    if (diff == 2) return 'DOUBLE BOGEY';
    return '+$diff';
  }

  Color _getScoreColor(int score, int par) {
    final diff = score - par;
    if (diff <= -1) return const Color(0xFF76F316);
    if (diff == 0) return Colors.white;
    if (diff == 1) return Colors.orange;
    return Colors.red;
  }
  Widget _buildHoleImage(Hole hole) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageViewer(
            imagePath: hole.imagePath,
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      height: 220,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 30,
            offset: Offset(0, 15),
            spreadRadius: -8,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              hole.imagePath,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 220,
                  color: const Color(0xFF2A2A2A),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Image not available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontFamily: 'Lexend',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Gradient overlay for better text visibility
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.zoom_out_map,
                          color: Colors.white.withOpacity(0.9),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'TAP TO VIEW FULL IMAGE',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
bool _areAllHolesScored() {
  return _scores.length == _holes.length && 
         _scores.values.every((score) => score > 0);
}

Widget _buildFinishRoundButton() {
  final allScored = _areAllHolesScored();
  
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF121212).withOpacity(0.95),
          const Color(0xFF121212),
        ],
      ),
    ),
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: allScored ? const Color(0xFF76F316) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: allScored ? [
          BoxShadow(
            color: const Color(0xFF76F316).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: allScored ? () async {
            // Save the round to database
            await _saveRound();
            
            // Check if this is a personal best
            final bestRound = await DatabaseHelper.instance.getBestRoundForCourse(_course!.id!);
            final isPersonalBest = bestRound != null && bestRound.totalScore == _getTotalScore();
            
            // Navigate to summary
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoundSummaryPage(
                    courseName: _course?.name ?? 'Unknown Course',
                    totalScore: _getTotalScore(),
                    coursePar: _getTotalPar(),
                    scoreToPar: _getScoreToPar(),
                    birdies: _countBirdies(),
                    pars: _countPars(),
                    bogeys: _countBogeys(),
                    isPersonalBest: isPersonalBest,
                  ),
                ),
              );
            }
          } : null,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  allScored ? 'Finish Round' : 'Score All Holes to Finish',
                  style: TextStyle(
                    color: allScored ? Colors.black : Colors.white.withOpacity(0.5),
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (allScored) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _saveRound() async {
  if (_course == null) return;
  
  try {
    // Create round object with hole scores as Map<int, int>
    final round = Round(
      courseId: _course!.id!,
      courseName: _course!.name,
      coursePar: _getTotalPar(),
      date: DateTime.now(),
      totalScore: _getTotalScore(),
      scoreToPar: _getScoreToPar(),
      eagles: _countEagles(),
      birdies: _countBirdies(),
      pars: _countPars(),
      bogeys: _countBogeys(),
      holeScores: _scores, // Pass the Map<int, int> directly
      isPersonalBest: false, // Will be updated by updatePersonalBests
    );
    
    // Save to database
    await DatabaseHelper.instance.saveRound(round);
    
    // Update personal bests for this course
    await DatabaseHelper.instance.updatePersonalBests(_course!.id!);
    
  } catch (e) {
    print('Error saving round: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving round: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

int _countEagles() {
  int count = 0;
  for (var hole in _holes) {
    final score = _scores[hole.holeNumber];
    if (score != null && score == hole.par - 2) {
      count++;
    }
  }
  return count;
}

int _countBirdies() {
  int count = 0;
  for (var hole in _holes) {
    final score = _scores[hole.holeNumber];
    if (score != null && score == hole.par - 1) {
      count++;
    }
  }
  return count;
}

int _countPars() {
  int count = 0;
  for (var hole in _holes) {
    final score = _scores[hole.holeNumber];
    if (score != null && score == hole.par) {
      count++;
    }
  }
  return count;
}

int _countBogeys() {
  int count = 0;
  for (var hole in _holes) {
    final score = _scores[hole.holeNumber];
    if (score != null && score == hole.par + 1) {
      count++;
    }
  }
  return count;
}
}