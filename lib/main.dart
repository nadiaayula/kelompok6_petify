import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'features/virtual_pet_wellbeings/screens/medical_record_screen.dart';
import 'features/virtual_pet_wellbeings/screens/add_medical_record_screen.dart';


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
      home: MedicalRecordScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
} 