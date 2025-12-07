import 'package:flutter/material.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/dashboard_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/medical_record_screen.dart';

class ShortcutPage extends StatelessWidget {
  const ShortcutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            // Removed 'SHORTCUT PAGE' text as per user request.
            // Padding(
            //   padding: const EdgeInsets.all(20),
            //   child: Text(
            //     'SHORTCUT PAGE',
            //     style: TextStyle(
            //       fontFamily: 'PlusJakartaSans',
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.grey[600],
            //       letterSpacing: 1,
            //     ),
            //   ),
            // ),
            
            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                children: [
                    // Title
                    const Text(
                      'Pintasan Fitur',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Shortcut buttons
                    _buildShortcutButton(
                      context,
                      imagePath: 'assets/images/scvirtual.png',
                      onTap: () {
                        // TODO: Navigate to Virtual Wellbeings screen
                      },
                    ),
                    
                    const SizedBox(height: 0),
                    
                    _buildShortcutButton(
                      context,
                      imagePath: 'assets/images/scfoster.png',
                      onTap: () {
                        // TODO: Navigate to Foster screen
                      },
                    ),
                    
                    const SizedBox(height: 0),
                    
                    _buildShortcutButton(
                      context,
                      imagePath: 'assets/images/scmedical.png',
                      onTap: () {
                        // TODO: Navigate to Medical Check screen
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Action buttons
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
                            'assets/images/buttonhome.png',
                            height: 60,
                            width: 60,
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
                            'assets/images/buttontutup.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      child: Container(
        padding: EdgeInsets.zero, // Remove padding to bring images closer
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 250, // Increase image size
              width: 250, // Increase image size
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.pets,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}