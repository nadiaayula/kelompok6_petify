import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../common/widgets/calendar_modal.dart';
import '../../../common/widgets/shortcut_page.dart';
import 'jenis_vaksinasi_modal.dart';

class AddVaksinScreen extends StatefulWidget {
  const AddVaksinScreen({super.key});

  @override
  State<AddVaksinScreen> createState() => _AddVaksinScreenState();
}

class _AddVaksinScreenState extends State<AddVaksinScreen> {
  DateTime? _selectedDate;
  String? _selectedVaksin;
  String? _selectedVaksinImage;
  bool _isLoading = false;
  List<Map<String, dynamic>> _pets = [];
  String? _selectedPetId;
  List<Map<String, dynamic>> _clinics = [];
  Map<String, dynamic>? _selectedClinic;
  String _selectedCountryCode = '🇮🇩';

  final _medicalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPets();
    _fetchClinics();
  }

  Future<void> _fetchClinics() async {
    try {
      final response = await Supabase.instance.client.from('clinic').select();
      setState(() {
        _clinics = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching clinics: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data klinik: $e')),
      );
    }
  }

  Future<void> _fetchPets() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      print('Fetching pets for user ID: $userId'); // Debug print
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat memuat peliharaan: Pengguna tidak login.')),
        );
        return;
      }
      final response = await Supabase.instance.client
          .from('pets')
          .select('id, name')
          .eq('owner_id', userId);

      print('Supabase response: $response'); // Debug print

      setState(() {
        _pets = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching pets: $e'); // Debug print
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat peliharaan: $e')),
      );
    }
  }

  @override
  void dispose() {
    _medicalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // BACK BUTTON WITH BOX
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),

              // TITLE
              const Flexible(
                child: Text(
                  'Vaksinasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // MENU BUTTON
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 190),
                        child: ShortcutPage(),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<String>(
            value: _selectedPetId,
            hint: const Text('Pilih peliharaan'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedPetId = newValue;
              });
            },
            items: _pets.map<DropdownMenuItem<String>>((Map<String, dynamic> pet) {
              return DropdownMenuItem<String>(
                value: pet['id'],
                child: Text(pet['name']),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Data Klinik Section
          const Text(
            'Data Klinik',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),

          DropdownButtonFormField<Map<String, dynamic>>(
            value: _selectedClinic,
            hint: const Text('Pilih Klinik'),
            onChanged: (Map<String, dynamic>? newValue) {
              setState(() {
                _selectedClinic = newValue;
              });
            },
            items: _clinics.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> clinic) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: clinic,
                child: Text(clinic['name']),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          if (_selectedClinic != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dokter: ${_selectedClinic!['doctor_name'] ?? '-'}'),
                  const SizedBox(height: 4),
                  Text('Telepon: ${_selectedClinic!['phone'] ?? '-'}'),
                ],
              ),
            )
          ],

          const SizedBox(height: 25),


          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.calendar_today,
                  label: _selectedDate == null
                    ? 'Tanggal'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  onTap: () => _showCalendarModal(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.vaccines_outlined,
                  label: _selectedVaksin == null ? 'Vaksin' : _selectedVaksin!,
                  onTap: () => _showVaksinModal(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedVaksinImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Image.asset(
                _selectedVaksinImage!,
                height: 100, // You can adjust the height as needed
              ),
            ),

          _buildTextField(
            hint: 'Catatan medis',
            maxLines: 3,
            controller: _medicalNotesController,
          ),
          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveVaccinationRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : const Text(
                      'Simpan',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _saveVaccinationRecord() async {
    if (_selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih peliharaan.')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal vaksinasi.')),
      );
      return;
    }
    if (_selectedVaksin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis vaksin.')),
      );
      return;
    }
    if (_selectedClinic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih klinik.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final vaccinationRecord = {
        'pet_id': _selectedPetId,
        'vaccination_date': _selectedDate!.toIso8601String(),
        'vaccine_name': _selectedVaksin,
        'medical_notes': _medicalNotesController.text,
        'clinic_id': _selectedClinic!['id'],
      };

      await Supabase.instance.client.from('vaccination_records').insert(vaccinationRecord);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan vaksinasi berhasil disimpan!')),
      );
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan catatan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB7B7B7),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }



  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE5E5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFFFF6B6B),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendarModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: const CalendarModal(),
      ),
    ).then((date) {
      if (date != null) {
        setState(() {
          _selectedDate = date;
        });
      }
    });
  }

  void _showVaksinModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const JenisVaksinasiModal(),
    ).then((result) {
      if (result != null && result is Map<String, String>) {
        setState(() {
          _selectedVaksin = result['name'];
          if (result['category'] == 'Vaksin Anjing') {
            _selectedVaksinImage = 'assets/images/iconanjingmed.png';
          } else if (result['category'] == 'Vaksin Kucing') {
            _selectedVaksinImage = 'assets/images/iconkucingmed.png';
          } else {
            _selectedVaksinImage = null; // Clear if category is not dog or cat
          }
        });
      }
    });
  }
}