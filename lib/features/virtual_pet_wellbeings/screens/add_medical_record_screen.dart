import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../common/widgets/calendar_modal.dart';
import '../../../common/widgets/shortcut_page.dart';
import '../../../common/widgets/success_dialog.dart';
import '../../../common/widgets/failure_dialog.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  const AddMedicalRecordScreen({super.key});

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  DateTime? _selectedDate;
  bool _isLoading = false;
  List<Map<String, dynamic>> _pets = [];
  String? _selectedPetId;
  bool _hasXray = false;
  List<Map<String, dynamic>> _clinics = [];
  Map<String, dynamic>? _selectedClinic;

  final _healthConditionController = TextEditingController();
  final _weightController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _medicalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPets();
    _fetchClinics();
  }

  @override
  void dispose() {
    _healthConditionController.dispose();
    _weightController.dispose();
    _additionalInfoController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }

  T? _firstWhereOrNull<T>(List<T> list, bool Function(T element) test) {
    for (var element in list) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  Future<void> _fetchPets() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final response = await Supabase.instance.client
          .from('pets')
          .select('id, name, weight_kg')
          .eq('owner_id', userId);

      setState(() {
        _pets = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching pets: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data peliharaan: $e')),
      );
    }
  }

  Future<void> _fetchClinics() async {
    try {
      print('🔍 Fetching clinics...');
      final response = await Supabase.instance.client.from('clinic').select();
      print('🔍 Clinics response: $response');

      if (response != null) {
        final List<Map<String, dynamic>> clinics =
            List<Map<String, dynamic>>.from(response);
        setState(() {
          _clinics = clinics;
        });
        print('✅ Clinics loaded: ${clinics.length}');
      } else {
        print('⚠️ No clinics data returned from Supabase.');
      }
    } catch (e) {
      print('❌ Error fetching clinics: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data klinik: $e')),
      );
    }
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
              const Flexible(
                child: Text(
                  'Medical Record',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        insetPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 190),
                        child: const ShortcutPage(),
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
          const Text(
            'Data Peliharaan',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<Map<String, dynamic>>(
            value: _selectedPetId == null
                ? null
                : _firstWhereOrNull(_pets, (pet) => pet['id'] == _selectedPetId),
            hint: const Text('Pilih peliharaan'),
            onChanged: (Map<String, dynamic>? newValue) {
              setState(() {
                _selectedPetId = newValue?['id'];
                _weightController.text =
                    (newValue?['weight_kg'] ?? '').toString();
              });
            },
            items: _pets.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> pet) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: pet,
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
          const SizedBox(height: 12),
          _buildTextField(
              hint: 'Kondisi kesehatan',
              controller: _healthConditionController),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                    hint: 'Berat peliharaan', controller: _weightController),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Kg',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            hint: 'Informasi tambahan',
            maxLines: 3,
            controller: _additionalInfoController,
          ),
          const SizedBox(height: 25),
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
            items: _clinics.map<DropdownMenuItem<Map<String, dynamic>>>(
                (Map<String, dynamic> clinic) {
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
          const SizedBox(height: 12),
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
                  icon: Icons.image_outlined,
                  label: 'X-Ray',
                  onTap: () {
                    setState(() {
                      _hasXray = !_hasXray;
                    });
                  },
                  isActive: _hasXray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            hint: 'Catatan medis',
            maxLines: 3,
            controller: _medicalNotesController,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveMedicalRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
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

  Future<void> _saveMedicalRecord() async {
    if (_selectedPetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih peliharaan.')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal kunjungan.')),
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
      final newWeight = double.tryParse(_weightController.text);
      if (newWeight != null) {
        await Supabase.instance.client
            .from('pets')
            .update({'weight_kg': newWeight}).eq('id', _selectedPetId!);
      }

      final combinedNotes = [
        _additionalInfoController.text,
        _medicalNotesController.text,
      ].where((note) => note.isNotEmpty).join('\n\n');

      final medicalRecord = {
        'pet_id': _selectedPetId,
        'visit_date': _selectedDate!.toIso8601String(),
        'pet_health_condition': _healthConditionController.text,
        'has_xray': _hasXray,
        'medical_notes': combinedNotes,
        'clinic_id': _selectedClinic!['id'],
      };

      await Supabase.instance.client
          .from('medical_records')
          .insert(medicalRecord);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => SuccessDialog(
          title: 'Berhasil',
          content: 'Medical record berhasil ditambahkan',
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => const FailureDialog(
          title: 'Gagal',
          content: 'Medical record gagal ditambahkan',
        ),
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
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF6B6B) : const Color(0xFFFFE5E5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFFFF6B6B),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFFFF6B6B),
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
}
