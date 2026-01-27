import 'package:flutter/material.dart';
import 'package:discpro/screens/login_page.dart';
import 'package:discpro/screens/home_page.dart'; // Assuming you have a home page
import 'package:discpro/screens/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DiscPro',
      theme: ThemeData(
        // Use colorScheme for modern theming
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),

        // Define the default ElevatedButton theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text color
            backgroundColor: Colors.deepPurple, // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(), // Create a simple HomePage for this route
        '/register': (context) => const RegisterPage(), // Create a simple RegisterPage for this route
      },
    );
  }
}