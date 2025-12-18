import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        // Dashboard
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        // Rewards
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: '',
        ),
        // VPM
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: '',
        ),
        // Medical
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: '',
        ),
        // Profile
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
    );
  }
}