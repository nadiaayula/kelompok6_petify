import 'package:flutter/material.dart';
import 'add_medical_record_screen.dart';
import 'add_vaksin_screen.dart';
import 'dashboard_screen.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
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
              
              // Positioned Image pet_doctors (tidak clickable lagi)
              Positioned(
                top: 60,
                child: Image.asset(
                  'assets/images/pet_doctors.png',
                  height: 220,
                ),
              ),
              
              // Add New Buttons (vaksinasi + tambah medical) di atas pet_doctors
              Positioned(
                top: 150, // sesuaikan untuk posisi vertikal
                right: 40, // sesuaikan untuk posisi horizontal
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AddVaksinScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 64, // area tap lebih besar
                          height: 64,
                          child: Center(
                            child: Image.asset(
                              'assets/images/vaksinasi.png',
                              width: 48, // ukuran gambar lebih besar
                              height: 48,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8), // jarak lebih rapat

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AddMedicalRecordScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 64, // area tap lebih besar
                          height: 64,
                          child: Center(
                            child: Image.asset(
                              'assets/images/add_medical.png',
                              width: 48, // ukuran gambar lebih besar
                              height: 48,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
      // BACK BUTTON WITH BOX
      Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // kotak rounded
        ),
        child: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: Colors.black87,
        ),
      ),
      
      SizedBox(width: 15),

      // SEARCH BAR
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

              // FILTER ICON (no box)
              Image.asset(
                'assets/images/filter.png',
                width: 48,
                height: 48,
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
                  icon: 'assets/images/iconkucingmed.png',
                  iconSize: 64,
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                _buildMedicalCard(
                  icon: 'assets/images/iconkucingmed.png',
                  iconSize: 64,
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
                  icon: 'assets/images/iconanjingmed.png',
                  iconSize: 64,
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, 14 Januari 2024 · 09:45 AM',
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
                  icon: 'assets/images/iconkucingmed.png',
                  iconSize: 64,
                  title: 'Vaksin Feline Calicivirus',
                  date: 'Sabtu, 4 Maret 2024 · 12:43 PM',
                  clinic: 'Klinik Sayang Hewan Indonesia',
                ),
                _buildMedicalCard(
                  icon: 'assets/images/iconanjingmed.png',
                  iconSize: 64,
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, 14 Januari 2024 · 09:45 AM',
                  clinic: 'Klinik Peduli Anabul Indonesia',
                  iconColor: Colors.purple,
                ),
                _buildMedicalCard(
                  icon: 'assets/images/iconkucingmed.png',
                  iconSize: 64,
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
                  icon: 'assets/images/iconanjingmed.png',
                  iconSize: 64,
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, 15 Januari 2024 · 09:45 AM',
                  clinic: 'Klinik Peduli Anabul Indonesia',
                  iconColor: Colors.purple,
                ),
                _buildMedicalCard(
                  icon: 'assets/images/iconanjingmed.png',
                  iconSize: 64,
                  title: 'Vaksin Parainfluenza',
                  date: 'Jumat, 15 Januari 2024 · 09:45 AM',
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
                  icon: 'assets/images/iconkucingmed.png',
                  iconSize: 64,
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
    double iconSize = 35,
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
            
            child: Center(
              child: Image.asset(
                icon,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
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