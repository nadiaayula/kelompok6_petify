import 'package:flutter/material.dart';

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

  void _submit() {
    if (!_validateForm()) return;

    final payload = {
      'type': _selectedPetType,
      'breed': _selectedBreed,
      'name': _nameController.text.trim(),
      'gender': _selectedGender,
      'ageMonths': _ageMonths,
      'ageYears': _ageYears,
      'photos': _selectedPhotos,
    };

    debugPrint('ADD PET: $payload');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Peliharaan berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
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
          padding: const EdgeInsets.all(8.0), // Beri sedikit ruang agar tidak terlalu mepet
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100], // Warna background abu-abu muda
              borderRadius: BorderRadius.circular(12), // Kelengkungan sudut kotak
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new, // Gunakan icon yang sama dengan home
                color: Colors.grey, // Warna icon abu-abu
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Virtual Wellbeings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== KATEGORI HEWAN (GAMBAR ONLY) ==================
            const Text(
              'Kategori hewan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih hewan yang ingin ditambahkan',
              style: TextStyle(fontSize: 14, color: Colors.grey),
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

            // ================== RAS/JENIS ==================
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

            // ================== NAMA ==================
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

            // ================== GENDER ==================
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

            // ================== UMUR ==================
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

            const SizedBox(height: 26),

            // ================== FOTO (dummy) ==================
            const Text(
              'Foto peliharaanmu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Utama', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('${_selectedPhotos.length} dari 5', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hasPhoto = index < _selectedPhotos.length;

                      return GestureDetector(
                        onTap: () {
                          if (_selectedPhotos.length < 5) {
                            setState(() {
                              _selectedPhotos.add('photo_${_selectedPhotos.length + 1}');
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: hasPhoto ? Colors.transparent : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              hasPhoto ? Icons.image : Icons.add,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Maksimal 5 foto', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================== BUTTON ==================
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: const Text(
                  'Tambahkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  // ================== UI HELPERS ==================

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
            width: 1,
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
      child: Column(
        children: [
          AnimatedScale(
            scale: isSelected ? 1.06 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: Image.asset(
              isSelected ? selectedImage : idleImage,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}