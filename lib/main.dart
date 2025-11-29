import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    url: 'https://cdfcsdwkpkkecssujmxk.supabase.co',
    anonKey: const String.fromEnvironment('SUPABASE_ANON'),
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
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      home: VpmHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}