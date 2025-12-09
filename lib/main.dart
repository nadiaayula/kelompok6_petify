import 'package:kelompok6_adoptify/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kelompok6_adoptify/features/auth/screens/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'features/virtual_pet_wellbeings/screens/medical_record_screen.dart';
import 'features/virtual_pet_wellbeings/screens/add_medical_record_screen.dart';
import 'features/virtual_pet_wellbeings/screens/dashboard_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON']!,
  );

  print('Supabase client initialized: ${Supabase.instance.client}');
  runApp(const MyApp());
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
      home: const MedicalRecordScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}