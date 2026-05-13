import 'package:flutter/material.dart';

class RoundSummaryPage extends StatelessWidget {
  final String courseName;
  final int totalScore;
  final int coursePar;
  final int scoreToPar;
  final int birdies;
  final int pars;
  final int bogeys;
  final bool isPersonalBest;

  const RoundSummaryPage({
    Key? key,
    required this.courseName,
    required this.totalScore,
    required this.coursePar,
    required this.scoreToPar,
    required this.birdies,
    required this.pars,
    required this.bogeys,
    this.isPersonalBest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF182210),
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 80), // Space for top bar
                  _buildSummaryHeader(),
                  const SizedBox(height: 40),
                  _buildStatsSection(),
                  const SizedBox(height: 200), // Space for bottom gradient
                ],
              ),
            ),
            
            // Top bar
            _buildTopBar(context),
            
            // Bottom gradient with button
            _buildBottomSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xCC182210),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Text(
            'Round Summary',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader() {
    final scoreText = scoreToPar > 0 ? '+$scoreToPar' : '$scoreToPar';
    final scoreColor = const Color(0xFF76F316);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Round Complete!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF76F316),
              fontSize: 32,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.80,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            courseName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
              height: 1.25,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(height: 24),
          
          // Score display
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                scoreText,
                style: TextStyle(
                  color: scoreColor,
                  fontSize: 100,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -5,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 0),
                      blurRadius: 15,
                      color: const Color(0xFF76F316).withOpacity(0.40),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (isPersonalBest) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0x1976F316),
                border: Border.all(
                  color: const Color(0x3376F316),
                ),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Text(
                '🏆 NEW PERSONAL BEST',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF76F316),
                  fontSize: 14,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                  letterSpacing: 1.40,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

Widget _buildStatsSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        _buildStatCard('Total Score', '$totalScore', 'Par $coursePar'),
        const SizedBox(height: 12),
        _buildStatCard('Birdies', '$birdies', ''),
        const SizedBox(height: 12),
        _buildStatCard('Pars', '$pars', ''),
        const SizedBox(height: 12),
        _buildStatCard('Bogeys', '$bogeys', ''),
      ],
    ),
  );
}

Widget _buildStatCard(String label, String value, String subtitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: ShapeDecoration(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.white.withOpacity(0.10),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFA0A0A0),
            fontSize: 14,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w600,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildBottomSection(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.only(
          top: 48,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.50, 1.00),
            end: const Alignment(0.50, 0.00),
            colors: [
              const Color(0xFF182210),
              const Color(0xFF182210),
              const Color(0x00182210),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF76F316),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Text(
              'Done',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF182210),
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}