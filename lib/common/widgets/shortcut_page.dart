import 'package:flutter/material.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/dashboard_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/medical_record_screen.dart';

class ShortcutPage extends StatelessWidget {
  const ShortcutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
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
              
              const SizedBox(height: 60),
              
              // Virtual Wellbeings Button
              _buildShortcutButton(
                context,
                imagePath: 'assets/images/scvirtual.png',
                onTap: () {
                  // TODO: Navigate to Virtual Wellbeings screen
                },
              ),
              
              const SizedBox(height: 0),
              
              // Foster Button
              _buildShortcutButton(
                context,
                imagePath: 'assets/images/scfoster.png',
                onTap: () {
                  // TODO: Navigate to Foster screen
                },
              ),
              
              const SizedBox(height: 0),
              
              // Medical Check Button
              _buildShortcutButton(
                context,
                imagePath: 'assets/images/scmedical.png',
                onTap: () {
                  // TODO: Navigate to Medical Check screen
                },
              ),
              
              const SizedBox(height: 40),
              
              // Close/Tutup Button (Replaced with old buttons as requested)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the current dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MedicalRecordScreen()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/bottontutup.png', // Changed
                      height: 120,
                      width: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
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
        height: 100, // Reduced height to make section shorter
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
