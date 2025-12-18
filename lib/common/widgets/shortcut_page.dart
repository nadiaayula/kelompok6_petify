import 'package:flutter/material.dart';
import 'package:kelompok6_adoptify/features/dashboard/dashboard_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/medical_record_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/vpm_home_screen.dart'; // Import VPMHomeScreen

class ShortcutPage extends StatelessWidget {
  const ShortcutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              const Text(
                'Pintasan Fitur',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Virtual Wellbeings Button
              _buildShortcutButton(
                context,
                imagePath: 'assets/images/scvirtual.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const VpmHomeScreen()), // Navigate to VPMHomeScreen
                  );
                },
              ),
              
              // Medical Check Button
              _buildShortcutButton(
                context,
                imagePath: 'assets/images/scmedical.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MedicalRecordScreen()),
                  );
                },
              ),
              
              Transform.translate(
                offset: const Offset(0, -20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Changed to center
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const DashboardScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Image.asset(
                        'assets/images/bottonhome.png', // Changed
                                              height: 120,
                                              width: 120,                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10), // Added spacing
                    GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context); // Close the current dialog and return to previous screen
                                          },                      child: Image.asset(
                        'assets/images/bottontutup.png', // Changed
                                              height: 120,
                                              width: 120,                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcutButton(
    BuildContext context, {
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        imagePath,
        height: 95, // Reduced height to help fit content
        width: null, // Let width scale naturally
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Placeholder jika image tidak ada
          return Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.pets,
              size: 60,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
