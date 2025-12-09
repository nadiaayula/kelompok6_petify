import 'package:flutter/material.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/add_vaksin_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/dashboard_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/add_medical_record_screen.dart';

// 1. DATA MODEL
class MedicalRecord {
  final String icon;
  final String title;
  final String date;
  final String clinic;
  final String animalType; // Added for filtering
  final Color? iconColor;

  MedicalRecord({
    required this.icon,
    required this.title,
    required this.date,
    required this.clinic,
    required this.animalType,
    this.iconColor,
  });
}

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String _animalFilter = 'all'; // 'all', 'kucing', 'anjing'

  // 2. DATA SOURCE
  final List<MedicalRecord> _allRecords = [
    // Kemarin
    MedicalRecord(
      icon: 'assets/images/iconkucingmed.png',
      title: 'Vaksin Feline Calicivirus',
      date: 'Kemarin · 12:43 PM',
      clinic: 'Klinik Sayang Hewan Indonesia',
      animalType: 'kucing',
    ),
    MedicalRecord(
      icon: 'assets/images/iconkucingmed.png',
      title: 'Pemeriksaan Rutin Kucing',
      date: 'Kemarin · 15:00 PM',
      clinic: 'Klinik Sayang Hewan Indonesia',
      animalType: 'kucing',
    ),
    // Sabtu, 22 Maret 2024
    MedicalRecord(
      icon: 'assets/images/iconanjingmed.png',
      title: 'Vaksin Parainfluenza',
      date: 'Sabtu, 22 Maret 2024 · 09:45 AM',
      clinic: 'Klinik Peduli Anabul Indonesia',
      animalType: 'anjing',
      iconColor: Colors.purple,
    ),
    // Jumat, 21 Maret 2024
    MedicalRecord(
      icon: 'assets/images/iconkucingmed.png',
      title: 'Operasi Sterilisasi',
      date: 'Jumat, 21 Maret 2024 · 12:43 PM',
      clinic: 'Klinik Sayang Hewan Indonesia',
      animalType: 'kucing',
    ),
    // Rabu, 20 Maret 2024
    MedicalRecord(
      icon: 'assets/images/iconanjingmed.png',
      title: 'Pemeriksaan Gigi Anjing',
      date: 'Rabu, 20 Maret 2024 · 10:00 AM',
      clinic: 'Klinik Sehat Pet',
      animalType: 'anjing',
      iconColor: Colors.purple,
    ),
    MedicalRecord(
      icon: 'assets/images/iconkucingmed.png',
      title: 'Konsultasi Gizi',
      date: 'Rabu, 20 Maret 2024 · 11:30 AM',
      clinic: 'Klinik Sehat Pet',
      animalType: 'kucing',
    ),
    // Senin, 18 Maret 2024
    MedicalRecord(
      icon: 'assets/images/iconanjingmed.png',
      title: 'Vaksin Rabies Anjing',
      date: 'Senin, 18 Maret 2024 · 02:00 PM',
      clinic: 'Klinik Peduli Anabul Indonesia',
      animalType: 'anjing',
      iconColor: Colors.purple,
    ),
    MedicalRecord(
      icon: 'assets/images/iconkucingmed.png',
      title: 'Perawatan Kutu',
      date: 'Senin, 18 Maret 2024 · 03:15 PM',
      clinic: 'Klinik Sayang Hewan Indonesia',
      animalType: 'kucing',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 3. FILTERING LOGIC
    final List<MedicalRecord> filteredRecords = _allRecords.where((record) {
      final titleLower = record.title.toLowerCase();
      final searchQueryLower = _searchQuery.toLowerCase();
      final typeMatches = _animalFilter == 'all' || record.animalType == _animalFilter;
      return titleLower.contains(searchQueryLower) && typeMatches;
    }).toList();

    // 4. GROUPING AND BUILDING LIST ITEMS
    List<dynamic> listItems = [];
    if (_searchQuery.isEmpty) {
      Map<String, List<MedicalRecord>> groupedRecords = {};
      for (var record in filteredRecords) {
        // Simple date part extraction for grouping.
        String datePart = record.date.split('·')[0].trim();
        if (groupedRecords.containsKey(datePart)) {
          groupedRecords[datePart]!.add(record);
        } else {
          groupedRecords[datePart] = [record];
        }
      }
      
      groupedRecords.forEach((date, records) {
        listItems.add(date);
        listItems.addAll(records);
      });

    } else {
      listItems.addAll(filteredRecords);
    }


    return Scaffold(        backgroundColor: Colors.grey[50],
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
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/images/pet_doctors.png',
                    height: 220,
                    fit: BoxFit.contain, // Changed from fitWidth to contain to prevent cropping
                  ),
                ),
                
                // Add New Buttons (vaksinasi + tambah medical) di atas pet_doctors
                Positioned(
                  top: 150, // sesuaikan untuk posisi vertikal
                  left: 0, // Occupy full width for responsiveness
                  right: 0, // Occupy full width for responsiveness
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Push buttons to the right
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
                      const SizedBox(width: 60), // Add right padding to match original 'right: 40'
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const DashboardScreen()),
                          );
                        },
                        child: Container(
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
                      ),
        SizedBox(width: 15),
  
        // SEARCH BAR
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Penelusuran',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
              ),
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
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];
                  if (item is String) {
                    // Build a date header
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (item is MedicalRecord) {
                    // Build a medical card
                    return _buildMedicalCard(
                      icon: item.icon,
                      iconSize: 64,
                      title: item.title,
                      date: item.date,
                      clinic: item.clinic,
                      iconColor: item.iconColor,
                    );
                  }
                  return const SizedBox.shrink(); // Should not happen
                },
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