import 'package:flutter/material.dart';

class MedicalRecordScreen extends StatelessWidget {
  const MedicalRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none, // Allows the image to overflow the Stack's bounds
            alignment: Alignment.center,
            children: [
              // Pink Header Background
              Container(
                height: 180, // Defines the height of the pink area
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9A9A), Color(0xFFFF7B7B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Positioned Title
              Positioned(
                top: 70, // Moved down a bit
                child: Text(
                  'Medical Record',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Positioned Image, hanging off the bottom
              Positioned(
                top: 60, // Starts near the bottom of the pink container
                child: Image.asset(
                  'assets/images/pet_doctors.png',
                  height: 220, // Explicit height to control overflow
                ),
              ),
            ],
          ),
          
          // Spacer to push content down, avoiding overlap with the image
          SizedBox(height: 80), 

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 20),
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Penelusuran',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Spacer(),
                        Icon(Icons.search, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.qr_code_scanner, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // Medical Records List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Kemarin Section
                Text(
                  'Kemarin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildMedicalCard(
                  icon: '🐱',
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                _buildMedicalCard(
                  icon: '🐱',
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                
                SizedBox(height: 20),
                
                // Sabtu, 22 Maret 2024 Section
                Text(
                  'Sabtu, 22 Maret 2024',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildMedicalCard(
                  icon: '🐺',
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, Januar 2024 · 09:45 AM',
                  clinic: 'Klinik Peduli Anabul Indonesia',
                  iconColor: Colors.purple,
                ),
                
                SizedBox(height: 20),
                
                // Jumat, 21 Maret 2024 Section
                Text(
                  'Jumat, 21 Maret 2024',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildMedicalCard(
                  icon: '🐱',
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                _buildMedicalCard(
                  icon: '🐺',
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, Januar 2024 · 09:45 AM',
                  clinic: 'Klinik Peduli Anabul Indonesia',
                  iconColor: Colors.purple,
                ),
                _buildMedicalCard(
                  icon: '🐱',
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                
                SizedBox(height: 20),
                
                // Another Jumat, 21 Maret 2024 Section
                Text(
                  'Jumat, 21 Maret 2024',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildMedicalCard(
                  icon: '🐺',
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, Januar 2024 · 09:45 AM',
                  clinic: 'Klinik Peduli Anabul Indonesia',
                  iconColor: Colors.purple,
                ),
                _buildMedicalCard(
                  icon: '🐺',
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, Januar 2024 · 09:45 AM',
                  clinic: 'Klinik Peduli Anabul Indonesia',
                  iconColor: Colors.purple,
                ),
                
                SizedBox(height: 20),
                
                Text(
                  'Jumat, 21 Maret 2024',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                _buildMedicalCard(
                  icon: '🐱',
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMedicalCard({
    required String icon,
    required String title,
    required String date,
    required String clinic,
    Color? iconColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.orange).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                icon,
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  clinic,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}