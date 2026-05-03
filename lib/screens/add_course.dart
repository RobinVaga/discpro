import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:discpro/widgets/bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:discpro/database/database_helper.dart';
import 'package:discpro/models/course.dart';
import 'package:discpro/models/hole.dart';

const Color primaryColor = Color(0xFF6BF906);
const Color backgroundDark = Color(0xFF121212);
const Color surfaceDark = Color(0xFF1E1E1E);

class HoleData {
  final int holeNumber;
  final TextEditingController parController;
  final TextEditingController distanceController;

  HoleData({
    required this.holeNumber,
    required this.parController,
    required this.distanceController,
  });
}

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _numberOfHolesController = TextEditingController();
  final TextEditingController _totalDistanceController = TextEditingController();
  
  List<HoleData> _holes = [];
  int _totalPar = 0;

  @override
  void dispose() {
    _courseNameController.dispose();
    _numberOfHolesController.dispose();
    _totalDistanceController.dispose();
    for (var hole in _holes) {
      hole.parController.dispose();
      hole.distanceController.dispose();
    }
    super.dispose();
  }

  void _updateNumberOfHoles(String value) {
    final int? numberOfHoles = int.tryParse(value);
    if (numberOfHoles != null && numberOfHoles > 0 && numberOfHoles <= 27) {
      setState(() {
        // Clear existing holes
        for (var hole in _holes) {
          hole.parController.dispose();
          hole.distanceController.dispose();
        }
        
        // Create new holes
        _holes = List.generate(
          numberOfHoles,
          (index) => HoleData(
            holeNumber: index + 1,
            parController: TextEditingController(text: '3'),
            distanceController: TextEditingController(),
          ),
        );
        
        _calculateTotalPar();
      });
    }
  }

  void _calculateTotalPar() {
    int total = 0;
    for (var hole in _holes) {
      final par = int.tryParse(hole.parController.text) ?? 0;
      total += par;
    }
    setState(() {
      _totalPar = total;
    });
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
              // Main content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 180),
                  child: Column(
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 24),
                      _buildFormContent(),
                    ],
                  ),
                ),
              ),
              
              // Bottom section with button and nav
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCreateButton(),
                    const SizedBox(height: 16),
                    const BottomNavBar(
                      activeItem: 'ADD',
                      showAddButton: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundDark.withOpacity(0.95),
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
                color: surfaceDark,
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
          const Text(
            'Add Custom Track',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.45,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Details Section
          const Text(
            'Course Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            'Course Name',
            'Enter course name',
            controller: _courseNameController,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            'Number of Holes',
            'e.g., 18',
            controller: _numberOfHolesController,
            keyboardType: TextInputType.number,
            onChanged: _updateNumberOfHoles,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            'Total Distance',
            'e.g., 2.5 km',
            controller: _totalDistanceController,
          ),
          
          // Hole Details Section
          if (_holes.isNotEmpty) ...[
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hole Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Total Par: $_totalPar',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Hole input fields
            ..._holes.map((hole) => _buildHoleInput(hole)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: surfaceDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHoleInput(HoleData hole) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Hole number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                '#${hole.holeNumber}',
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Par input
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PAR',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 0),
                Row(
                  children: [
                    _buildCounterButton(
                      Icons.remove,
                      () {
                        final currentPar = int.tryParse(hole.parController.text) ?? 3;
                        if (currentPar > 1) {
                          hole.parController.text = (currentPar - 1).toString();
                          _calculateTotalPar();
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: hole.parController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => _calculateTotalPar(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    _buildCounterButton(
                      Icons.add,
                      () {
                        final currentPar = int.tryParse(hole.parController.text) ?? 3;
                        if (currentPar < 9) {
                          hole.parController.text = (currentPar + 1).toString();
                          _calculateTotalPar();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Distance input
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DISTANCE (M)',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: hole.distanceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: '320',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.6),
          size: 16,
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              // Validate course name
              if (_courseNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a course name')),
                );
                return;
              }
              
              // Validate holes
              if (_holes.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add at least one hole')),
                );
                return;
              }
              
              // Validate that all holes have distances
              bool hasEmptyDistance = _holes.any((hole) => hole.distanceController.text.isEmpty);
              if (hasEmptyDistance) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter distance for all holes')),
                );
                return;
              }
              
              try {
                // Calculate total distance from holes
                double totalDistance = 0;
                for (var hole in _holes) {
                  totalDistance += double.tryParse(hole.distanceController.text) ?? 0;
                }
                // Convert meters to kilometers
                totalDistance = totalDistance / 1000;
                
                // Create Course object
                final course = Course(
                  name: _courseNameController.text,
                  details: 'Custom course with ${_holes.length} holes',
                  par: _totalPar.toString(),
                  imagePath: 'assets/images/default_course.webp',
                  holes: _holes.length,
                  distance: totalDistance,
                  latitude: 0.0,
                  longitude: 0.0,
                );
                
                // Create Hole objects
                final holes = _holes.map((holeData) {
                  return Hole(
                    holeNumber: holeData.holeNumber,
                    par: int.tryParse(holeData.parController.text) ?? 3,
                    distance: double.tryParse(holeData.distanceController.text) ?? 0,
                    elevation: 0.0,
                    imagePath: 'assets/images/default_hole.webp',
                  );
                }).toList();
                
                // Save to database
                final courseId = await DatabaseHelper.instance.insertCourseWithHoles(course, holes);
                
                if (!mounted) return;
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Course "${_courseNameController.text}" created successfully!'),
                    backgroundColor: primaryColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
                
                // Navigate back after a short delay
                await Future.delayed(const Duration(milliseconds: 500));
                if (!mounted) return;
                Navigator.pop(context, true);
                
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating course: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: const Center(
              child: Text(
                'Create Layout',
                style: TextStyle(
                  color: backgroundDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}