import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Wajib ada

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  String? _selectedPetType; // 'Kucing' / 'Anjing'
  String? _selectedBreed;
  String? _selectedGender; // 'Jantan' / 'Betina'
  int? _ageMonths;
  int? _ageYears;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();

  final List<String> _catBreeds = ['Angora', 'Domestik', 'Ragdoll', 'Persian', 'Siamese'];
  final List<String> _dogBreeds = ['Golden Retriever', 'Poodle', 'Bulldog', 'Beagle'];

  final List<String> _selectedPhotos = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  List<String> _getAvailableBreeds() {
    if (_selectedPetType == 'Kucing') return _catBreeds;
    if (_selectedPetType == 'Anjing') return _dogBreeds;
    return [];
  }

  bool _validateForm() {
    if (_selectedPetType == null) {
      _showError('Pilih kategori hewan dulu ya');
      return false;
    }
    if (_selectedBreed == null) {
      _showError('Pilih ras/jenis hewan');
      return false;
    }
    if (_nameController.text.trim().isEmpty) {
      _showError('Masukkan nama peliharaan');
      return false;
    }
    if (_selectedGender == null) {
      _showError('Pilih jenis kelamin');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // FUNGSI SIMPAN KE SUPABASE (Update di add_pet_screen.dart)
  Future<void> _submit() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw 'User tidak ditemukan. Silakan login kembali.';

      final now = DateTime.now();
      final birthDate = DateTime(
        now.year - (_ageYears ?? 0),
        now.month - (_ageMonths ?? 0),
        now.day,
      );

      // INSERT KE TABEL 'pets'
      await Supabase.instance.client.from('pets').insert({
        'owner_id': user.id,
        'name': _nameController.text.trim(),
        'species': _selectedPetType == 'Kucing' ? 'cat' : 'dog', // Sesuaikan jika enum species juga bahasa Inggris
        'breed': _selectedBreed,
        'gender': _selectedGender == 'Jantan' ? 'male' : 'female', 
        'birth_date': birthDate.toIso8601String(),
        'weight_kg': 0.0,
        'image_url': _selectedPetType == 'Kucing' 
            ? 'assets/images/icon_cat_main.png' 
            : 'assets/images/icon_dog_main.png',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Peliharaan berhasil ditambahkan!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('ERROR ADD PET: $e');
      _showError('Gagal menyimpan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Virtual Wellbeings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori hewan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PetImageSelector(
                      title: 'Kucing',
                      isSelected: _selectedPetType == 'Kucing',
                      idleImage: 'assets/images/cat_idle.png',
                      selectedImage: 'assets/images/cat_selected.png',
                      onTap: () {
                        setState(() {
                          _selectedPetType = 'Kucing';
                          _selectedBreed = null;
                        });
                      },
                    ),
                    PetImageSelector(
                      title: 'Anjing',
                      isSelected: _selectedPetType == 'Anjing',
                      idleImage: 'assets/images/dog_idle.png',
                      selectedImage: 'assets/images/dog_selected.png',
                      onTap: () {
                        setState(() {
                          _selectedPetType = 'Anjing';
                          _selectedBreed = null;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const Text(
                  'Ras atau jenis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                const SizedBox(height: 12),
                _dropdownBox<String>(
                  value: _selectedBreed,
                  hint: _selectedPetType == null ? 'Pilih kategori hewan dulu' : 'Pilih ras/jenis',
                  enabled: _selectedPetType != null,
                  items: _getAvailableBreeds(),
                  onChanged: (val) => setState(() => _selectedBreed = val),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Nama peliharaanmu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration('Nama'),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Jenis kelamin peliharaanmu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _genderButton('Jantan')),
                    const SizedBox(width: 12),
                    Expanded(child: _genderButton('Betina')),
                  ],
                ),
                const SizedBox(height: 26),
                const Text(
                  'Umur peliharaanmu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _ageDropdown(unit: 'Bulan')),
                    const SizedBox(width: 12),
                    Expanded(child: _ageDropdown(unit: 'Tahun')),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA726),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Tambahkan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
          // Loading Overlay jika sedang submit
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CircularProgressIndicator(color: Colors.orange)),
            ),
        ],
      ),
    );
  }

  // UI HELPERS (tetap sama)
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _dropdownBox<T>({
    required T? value,
    required String hint,
    required bool enabled,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: _inputDecoration(hint),
      hint: Text(hint),
      items: enabled
          ? items.map((e) => DropdownMenuItem<T>(value: e, child: Text(e.toString()))).toList()
          : null,
      onChanged: enabled ? onChanged : null,
    );
  }

  Widget _genderButton(String gender) {
    final selected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFA726) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFFFA726) : Colors.grey.shade200,
          ),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ageDropdown({required String unit}) {
    final isMonth = unit == 'Bulan';
    final selected = isMonth ? _ageMonths : _ageYears;
    final options = List.generate(isMonth ? 12 : 30, (i) => i + 1);
    return DropdownButtonFormField<int>(
      value: selected,
      isExpanded: true,
      decoration: _inputDecoration(unit),
      hint: Text(unit),
      items: options.map((e) => DropdownMenuItem(value: e, child: Text('$e $unit'))).toList(),
      onChanged: (val) {
        setState(() {
          if (isMonth) {
            _ageMonths = val;
          } else {
            _ageYears = val;
          }
        });
      },
    );
  }
}

class PetImageSelector extends StatelessWidget {
  final String title;
  final bool isSelected;
  final String idleImage;
  final String selectedImage;
  final VoidCallback onTap;

  const PetImageSelector({
    super.key,
    required this.title,
    required this.isSelected,
    required this.idleImage,
    required this.selectedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.06 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: Image.asset(
          isSelected ? selectedImage : idleImage,
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}