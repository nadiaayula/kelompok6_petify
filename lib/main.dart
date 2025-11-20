import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'features/virtual_pet_wellbeings/screens/medical_record_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: MedicalRecordScreen(), // Changed to MedicalRecordScreen
      debugShowCheckedModeBanner: false,
    );
  }
}