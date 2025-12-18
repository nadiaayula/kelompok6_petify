import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Keep this import
import 'package:kelompok6_adoptify/features/auth/screens/login_screen.dart'; // Keep this import
// Auth screens
import 'features/auth/screens/splash_welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
// Virtual Pet Wellbeings screens
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'features/medical_record/medical_record_screen.dart';
import 'features/medical_record/add_medical_record_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
// Other features
import 'features/history/history_page.dart';
import 'features/rewards/screens/rewards_page.dart';
import 'owner_profile/profile_page.dart';
// Main Navigation (dengan bottom navbar)
import 'main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  print('Supabase client initialized: ${Supabase.instance.client}');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      print('Auth event: $event');
      
      if (event == AuthChangeEvent.signedIn) {
        print('User signed in: ${data.session?.user.email}');
      }
    });
  }

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('id', ''),
      ],
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const MainNavigation(),
        '/vpm': (context) => const VpmHomeScreen(),
      },
    );
  }
}