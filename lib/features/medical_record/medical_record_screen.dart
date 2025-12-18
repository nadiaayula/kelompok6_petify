import 'package:flutter/material.dart';
import 'package:kelompok6_adoptify/features/medical_record/add_vaksin_screen.dart';
import 'package:kelompok6_adoptify/features/dashboard/dashboard_screen.dart';
import 'package:kelompok6_adoptify/features/medical_record/add_medical_record_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// 1. DATA MODEL
class MedicalRecord {
  final String id;
  final String petId;
  final String petName;
  final String petSpecies;
  final String? petImageUrl;
  final String title;
  final DateTime recordDate;
  final String? clinicName;
  final String? doctorName;
  final String recordType;
  final String? medicalNotes;
  final String? healthCondition;
  final bool? hasXray;
  final String? vaccineName;
  MedicalRecord({
    required this.id,
    required this.petId,
    required this.petName,
    required this.petSpecies,
    this.petImageUrl,
    required this.title,
    required this.recordDate,
    this.clinicName,
    this.doctorName,
    required this.recordType,
    this.medicalNotes,
    this.healthCondition,
    this.hasXray,
    this.vaccineName,
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
  bool _isLoading = false;
  List<MedicalRecord> _supaRecords = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    _fetchRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat memuat catatan: Pengguna tidak login.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Base query for Medical Records
      var medicalQuery = Supabase.instance.client
          .from('medical_records')
          .select('*, pets(name, species, image_url), clinic(name, doctor_name)')
          .eq('pets.owner_id', userId);

            // Apply species filter if not 'all', using case-insensitive 'ilike'

            if (_animalFilter != 'all') {

              medicalQuery = medicalQuery.ilike('pets.species', _animalFilter);

            }

            

            final medicalResponse = await medicalQuery.order('visit_date', ascending: false);

      

      

            // Filter out records where 'pets' is null and then map

            List<MedicalRecord> medicalRecords = (medicalResponse as List)

                .where((data) => data['pets'] != null)

                .map((data) {

              final petData = data['pets'] as Map<String, dynamic>;

              final clinicData = data['clinic'] as Map<String, dynamic>?;

              return MedicalRecord(

                id: data['id'],

                petId: data['pet_id'],

                petName: petData['name'],

                petSpecies: petData['species'],

                petImageUrl: petData['image_url'],

                title: 'Pemeriksaan Medis', // Generic title for medical records

                recordDate: DateTime.parse(data['visit_date']), // Use visit_date

                clinicName: clinicData?['name'],

                doctorName: clinicData?['doctor_name'],

                recordType: 'medical',

                medicalNotes: data['medical_notes'],

                healthCondition: data['pet_health_condition'],

                hasXray: data['has_xray'],

              );

            }).toList();

      

            // Base query for Vaccination Records

            var vaccinationQuery = Supabase.instance.client

                .from('vaccination_records')

                .select('*, pets(name, species, image_url), clinic(name)')

                .eq('pets.owner_id', userId);

      

            // Apply species filter if not 'all', using case-insensitive 'ilike'

            if (_animalFilter != 'all') {

              vaccinationQuery = vaccinationQuery.ilike('pets.species', _animalFilter);

            }

      

            final vaccinationResponse = await vaccinationQuery.order('vaccination_date', ascending: false);

      // Filter out records where 'pets' is null and then map
      List<MedicalRecord> vaccinationRecords = (vaccinationResponse as List)
          .where((data) => data['pets'] != null)
          .map((data) {
        final petData = data['pets'] as Map<String, dynamic>;
        final clinicData = data['clinic'] as Map<String, dynamic>?;
        return MedicalRecord(
          id: data['id'],
          petId: data['pet_id'],
          petName: petData['name'],
          petSpecies: petData['species'],
          petImageUrl: petData['image_url'],
          title: data['vaccine_name'], // Vaccine name as title
          recordDate: DateTime.parse(data['vaccination_date']), // Keep using vaccination_date
          recordType: 'vaccination',
          medicalNotes: data['medical_notes'],
          vaccineName: data['vaccine_name'],
          clinicName: clinicData?['name'],
        );
      }).toList();

      List<MedicalRecord> allFetchedRecords = [];
      allFetchedRecords.addAll(medicalRecords);
      allFetchedRecords.addAll(vaccinationRecords);

      // Sort all records by date
      allFetchedRecords.sort((a, b) => b.recordDate.compareTo(a.recordDate));

      setState(() {
        _supaRecords = allFetchedRecords;
      });
    } catch (e) {
      print('Error fetching records: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat catatan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. FILTERING LOGIC
    final List<MedicalRecord> filteredRecords = _supaRecords.where((record) {
      final titleLower = record.title.toLowerCase();
      final searchQueryLower = _searchQuery.toLowerCase();
      final typeMatches = _animalFilter == 'all' || record.petSpecies == _animalFilter;
      // Filter by petName as well
      final petNameLower = record.petName.toLowerCase();
      return (
        titleLower.contains(searchQueryLower) || 
        petNameLower.contains(searchQueryLower) ||
        (record.recordType == 'vaccination' && 'vaksin'.contains(searchQueryLower))
      ) && typeMatches;
    }).toList();

    // 4. GROUPING AND BUILDING LIST ITEMS
    List<dynamic> listItems = [];
    if (_searchQuery.isEmpty) {
      Map<String, List<MedicalRecord>> groupedRecords = {};
      for (var record in filteredRecords) {
        // Group by formatted date (e.g., "Hari Ini", "Kemarin", "Sabtu, 22 Maret 2024")
        String formattedDate = _formatDateForGrouping(record.recordDate);
        if (groupedRecords.containsKey(formattedDate)) {
          groupedRecords[formattedDate]!.add(record);
        } else {
          groupedRecords[formattedDate] = [record];
        }
      }
      
      groupedRecords.forEach((date, records) {
        listItems.add(date);
        listItems.addAll(records);
      });

    } else {
      listItems.addAll(filteredRecords);
    }


    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AddVaksinScreen()),
                            );
                            _fetchRecords();
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
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AddMedicalRecordScreen()),
                            );
                            _fetchRecords();
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
            const SizedBox(height: 80), 
  
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
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10), // kotak rounded
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
  
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
                          prefixIcon: const Icon(Icons.search, color: Colors.orange),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                        ),
                      ),
                    ),
                  ),
  
                  const SizedBox(width: 15),
  
                  // FILTER ICON (no box)
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        _animalFilter = value;
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'all',
                        child: Text('Semua'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'cat',
                        child: Text('Kucing'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'dog',
                        child: Text('Anjing'),
                      ),
                    ],
                    child: Image.asset(
                      'assets/images/filter.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ],
              ),
            ),
  
            const SizedBox(height: 20),
  
            
            // Medical Records List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];
                  if (item is String) {
                    // Build a date header
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (item is MedicalRecord) {
                    // Build a medical card
                    return _buildMedicalCard(item);
                  }
                  return const SizedBox.shrink(); // Should not happen
                },
              ),
            ),
          ],
        ),
    );
    }
  
  String _formatDateForGrouping(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final recordDate = DateTime(date.year, date.month, date.day);

    if (recordDate == today) {
      return 'Hari Ini';
    } else if (recordDate == yesterday) {
      return 'Kemarin';
    } else {
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date); // 'id_ID' for Indonesian
    }
  }

  Widget _buildMedicalCard(MedicalRecord item) {
    // Determine icon based on pet species
    Widget iconWidget;
    if (item.petImageUrl != null && item.petImageUrl!.isNotEmpty) {
      iconWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          item.petImageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback for network error
            return Image.asset(
              item.petSpecies.toLowerCase() == 'anjing'
                  ? 'assets/images/iconanjingmed.png'
                  : 'assets/images/iconkucingmed.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            );
          },
        ),
      );
    } else {
      // Fallback for no image URL
      iconWidget = Image.asset(
        item.petSpecies.toLowerCase() == 'anjing'
            ? 'assets/images/iconanjingmed.png'
            : 'assets/images/iconkucingmed.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      );
    }

    String subtitleText;
    String formattedDate;

    subtitleText = item.clinicName != null && item.clinicName!.isNotEmpty
        ? item.clinicName!
        : 'Klinik tidak diketahui';

    if (item.recordType == 'medical') {
      formattedDate = DateFormat('dd MMMM yyyy · hh:mm a', 'id_ID').format(item.recordDate);
    } else { // vaccination
      // For vaccination, show only the date part to avoid "12:00 AM"
      formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(item.recordDate);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: iconWidget,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.recordType == 'vaccination' ? 'Vaksin ${item.title}' : item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.petName} - $formattedDate', // Show pet name and date
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitleText,
                  style: const TextStyle(
                    color: Colors.orange, // Assuming clinic/notes text color is orange
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
