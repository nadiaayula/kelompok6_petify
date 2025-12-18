import 'package:flutter/material.dart';
import 'common/widgets/bottom_nav_bar.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/rewards/screens/rewards_page.dart';
import 'features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'features/virtual_pet_wellbeings/screens/medical_record_screen.dart';
import 'owner_profile/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),         // Dashboard
    RewardsPage(),             // Rewards
    VpmHomeScreen(),           // VPM
    MedicalRecordScreen(),     // Medical
    ProfilePage(),             // Profile
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}