import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/authentication/screens/splash_welcome_screen.dart';
import 'features/authentication/screens/create_account_screen.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: SplashWelcomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => CreateAccountScreen(), // Sementara pakai CreateAccount, nanti buat LoginScreen
        '/register': (context) => CreateAccountScreen(),
        '/home': (context) => VpmHomeScreen(),
      },
    );
  }
}