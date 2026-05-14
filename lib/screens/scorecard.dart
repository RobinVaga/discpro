import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discpro/database/database_helper.dart';
import 'package:discpro/models/course.dart';
import 'package:discpro/models/hole.dart';
import 'package:discpro/models/rounds.dart';
import 'package:discpro/screens/round_summary.dart';
import 'package:discpro/screens/fullscreen_image_viewer.dart';
import 'package:discpro/services/auth_service.dart';

class ActiveScorecardPage extends StatefulWidget {
  final int courseId;
  final int startingHole;

  const ActiveScorecardPage({
    super.key,
    required this.courseId,
    this.startingHole = 1,
  });

  @override
  State<ActiveScorecardPage> createState() => _ActiveScorecardPageState();
}

class _ActiveScorecardPageState extends State<ActiveScorecardPage> {
  Course? _course;
  List<Hole> _holes = [];
  bool _isLoading = true;
  int _currentHole = 1;
  final Map<int, int> _scores = {};
  late PageController _pageController;
  String _playerName = 'Player';

  @override
  void initState() {
    super.initState();
    _currentHole = widget.startingHole;
    _pageController = PageController(initialPage: widget.startingHole - 1);
    _loadCourseData();
    _loadPlayerName();
  }

  Future<void> _loadPlayerName() async {
    final user = await AuthService().currentUser;
    if (user != null && mounted) {
      setState(() {
        _playerName = user.fullName ?? user.username;
      });
    }
  }

  Future<void> _loadCourseData() async {
    setState(() => _isLoading = true);
    try {
      final course = await DatabaseHelper.instance.getCourse(widget.courseId);
      final holes = await DatabaseHelper.instance.getHolesByCourse(widget.courseId);
      
      setState(() {
        _course = course;
        _holes = holes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _incrementScore(int holeNumber) {
    setState(() {
      _scores[holeNumber] = (_scores[holeNumber] ?? 0) + 1;
    });
  }

  void _decrementScore(int holeNumber) {
    setState(() {
      if ((_scores[holeNumber] ?? 0) > 0) {
        _scores[holeNumber] = _scores[holeNumber]! - 1;
      }
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF76F316);
    const Color backgroundDark = Color(0xFF121212);

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: backgroundDark,
        body: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      );
    }

    if (_course == null || _holes.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white54,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Course data not available',
                style: GoogleFonts.lexend(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            
            // Hole Navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentHole > 1)
                        Icon(
                          Icons.chevron_left,
                          color: primaryColor.withOpacity(0.6),
                          size: 32,
                        )
                      else
                        const SizedBox(width: 32),
                      
                      const SizedBox(width: 8),
                      
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
                      
                      const SizedBox(width: 8),
                      
                      if (_currentHole < _holes.length)
                        Icon(
                          Icons.chevron_right,
                          color: primaryColor.withOpacity(0.6),
                          size: 32,
                        )
                      else
                        const SizedBox(width: 32),
                    ],
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
                      'PAR ${_holes[_currentHole - 1].par} | ${_holes[_currentHole - 1].distance}M',
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
            
            // Scorecard with swipe navigation
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _holes.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentHole = index + 1;
                  });
                },
                itemBuilder: (context, index) {
                  final hole = _holes[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 180),
                    physics: const ClampingScrollPhysics(),
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
      ),
      floatingActionButton: _buildFinishRoundButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              _course?.name ?? 'Scorecard',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.45,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHoleNavigator() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _holes.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final displayHole = index + 1;
          final isActive = _currentHole == displayHole;

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
        },
      ),
    );
  }

  Widget _buildPlayerScorecard(Hole hole) {
    const Color primaryColor = Color(0xFF76F316);
    final currentScore = _scores[hole.holeNumber] ?? 0;
    final scoreToPar = currentScore > 0 ? currentScore - hole.par : 0;

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
          // Player header with score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PLAYER 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _playerName,
                    style: const TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 14,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (_getTotalScore() > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'TOTAL: ${_getScoreToPar() > 0 ? '+${_getScoreToPar()}' : _getScoreToPar()}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: ShapeDecoration(
                  color: const Color(0x1976F316),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color(0x3376F316),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'HOLE SCORE',
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 10,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentScore == 0 ? '-' : '$currentScore',
                      style: const TextStyle(
                        color: Color(0xFF76F316),
                        fontSize: 48,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    if (currentScore > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        scoreToPar > 0 ? '+$scoreToPar' : scoreToPar == 0 ? 'PAR' : '$scoreToPar',
                        style: TextStyle(
                          color: scoreToPar < 0 ? primaryColor : 
                                 scoreToPar == 0 ? Colors.white : 
                                 scoreToPar == 1 ? Colors.orange : Colors.red,
                          fontSize: 12,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Score adjustment buttons
          Row(
            children: [
              // Minus button
              Expanded(
                child: GestureDetector(
                  onTap: () => _decrementScore(hole.holeNumber),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Plus button
              Expanded(
                child: GestureDetector(
                  onTap: () => _incrementScore(hole.holeNumber),
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
        height: 200,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          image: DecorationImage(
            image: AssetImage(hole.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Tap to expand hint
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.zoom_out_map,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'TAP TO EXPAND',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishRoundButton() {
    const Color primaryColor = Color(0xFF76F316);
    final hasScores = _scores.isNotEmpty;
    final allHolesCompleted = _scores.length == _holes.length && 
                              _scores.values.every((score) => score > 0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: hasScores ? _finishRound : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: allHolesCompleted ? primaryColor : Colors.grey[700],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: allHolesCompleted ? 8 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              allHolesCompleted ? Icons.check_circle : Icons.warning,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              allHolesCompleted 
                  ? 'FINISH ROUND' 
                  : 'COMPLETE ALL HOLES (${_scores.length}/${_holes.length})',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _finishRound() async {
  if (_scores.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter scores before finishing the round'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Check if all holes have scores
  final missingHoles = <int>[];
  for (var hole in _holes) {
    if (!_scores.containsKey(hole.holeNumber) || _scores[hole.holeNumber] == 0) {
      missingHoles.add(hole.holeNumber);
    }
  }

  if (missingHoles.isNotEmpty) {
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Incomplete Round',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'You haven\'t entered scores for holes: ${missingHoles.join(', ')}\n\nDo you want to finish anyway?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'FINISH ANYWAY',
              style: TextStyle(color: Color(0xFF76F316)),
            ),
          ),
        ],
      ),
    );

    if (shouldContinue != true) {
      return;
    }
  }

  try {
    // Calculate statistics
    int eagles = 0;
    int birdies = 0;
    int pars = 0;
    int bogeys = 0;

    for (var hole in _holes) {
      final score = _scores[hole.holeNumber] ?? 0;
      if (score > 0) {
        final diff = score - hole.par;
        if (diff <= -2) {
          eagles++;
        } else if (diff == -1) {
          birdies++;
        } else if (diff == 0) {
          pars++;
        } else if (diff == 1) {
          bogeys++;
        }
      }
    }

    final totalScore = _getTotalScore();
    final coursePar = _getTotalPar();
    final scoreToPar = totalScore - coursePar;

    // Create round object
    final round = Round(
      courseId: widget.courseId,
      courseName: _course!.name,
      coursePar: coursePar,
      totalScore: totalScore,
      scoreToPar: scoreToPar,
      eagles: eagles,
      birdies: birdies,
      pars: pars,
      bogeys: bogeys,
      date: DateTime.now(),
      holeScores: _scores,
    );

    // Save round to database
    final roundId = await DatabaseHelper.instance.saveRound(round);

    if (mounted) {
      // Navigate to round summary with individual parameters
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoundSummaryPage(
            courseName: _course!.name,
            totalScore: totalScore,
            coursePar: coursePar,
            scoreToPar: scoreToPar,
            birdies: birdies,
            pars: pars,
            bogeys: bogeys,
            isPersonalBest: false, // Will be determined later
          ),
        ),
      );
    }
  } catch (e) {
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
}