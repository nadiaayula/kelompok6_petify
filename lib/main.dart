import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'features/rewards/screens/rewards_page.dart';
//import 'features/virtual_pet_wellbeings/screens/dashboard_screen.dart';


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
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      home: const RewardsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}