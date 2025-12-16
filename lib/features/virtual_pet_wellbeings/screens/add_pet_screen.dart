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

    // sementara print dulu (nanti kamu ganti jadi insert supabase)
    debugPrint('ADD PET: $payload');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Peliharaan berhasil ditambahkan!'), backgroundColor: Colors.green),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
            // ================== KATEGORI HEWAN ==================
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

            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              children: [
                PetTypeCard(
                  title: 'Kucing',
                  selected: _selectedPetType == 'Kucing',
                  imageIdle: 'assets/images/cat_idle.png', 
                  imageSelected: 'assets/images/cat_selected.png',
                  selectedBg: const Color(0xFFFFE7C2),
                  unselectedBg: const Color(0xFFF2F2F2),
                  onTap: () {
                    setState(() {
                      _selectedPetType = 'Kucing';
                      _selectedBreed = null;
                    });
                  },
                ),
                PetTypeCard(
                  title: 'Anjing',
                  selected: _selectedPetType == 'Anjing',
                  imageIdle: 'assets/images/dog_idle.png', 
                  imageSelected: 'assets/images/dog_selected.png',
                  selectedBg: const Color(0xFFFFE7C2),
                  unselectedBg: const Color(0xFFF2F2F2),
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
                Expanded(
                  child: _genderButton('Jantan'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _genderButton('Betina'),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Foto peliharaanmu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ],
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
                              style: hasPhoto ? BorderStyle.solid : BorderStyle.solid,
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

class PetTypeCard extends StatelessWidget {
  final String title;
  final bool selected;
  final String imageIdle;
  final String imageSelected;
  final Color selectedBg;
  final Color unselectedBg;
  final VoidCallback onTap;

  const PetTypeCard({
    super.key,
    required this.title,
    required this.selected,
    required this.imageIdle,
    required this.imageSelected,
    required this.selectedBg,
    required this.unselectedBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Image.asset(
                selected ? imageSelected : imageIdle,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Virtual\nWellbeings',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}