import 'package:flutter/material.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  String? _selectedPetType;
  String? _selectedBreed;
  String? _selectedPetName;
  String? _selectedGender;
  int? _ageMonths;
  int? _ageYears;

  final List<String> _catBreeds = [
    'Angora',
    'Domestik',
    'Ragdoll',
    'Persian',
    'Siamese',
  ];

  final List<String> _dogBreeds = [
    'Golden Retriever',
    'Poodle',
    'Bulldog',
    'Beagle',
  ];

  List<String> _getAvailableBreeds() {
    if (_selectedPetType == 'Kucing') return _catBreeds;
    if (_selectedPetType == 'Anjing') return _dogBreeds;
    return [];
  }

  static const List<_PetTypeOption> _petTypeOptions = [
    _PetTypeOption(
      type: 'Kucing',
      icon: Icons.pets,
      color: Color(0xFFFFE7C2),
      accent: Color(0xFFFFA726),
    ),
    _PetTypeOption(
      type: 'Anjing',
      icon: Icons.pets,
      color: Color(0xFFF1F1F1),
      accent: Color(0xFF42A5F5),
    ),
  ];

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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title('Kategori hewan'),
            const SizedBox(height: 6),
            const Text(
              'Pilih hewan yang ingin ditambahkan',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// === KUCING & ANJING ===
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              itemCount: _petTypeOptions.length,
              itemBuilder: (context, index) {
                final pet = _petTypeOptions[index];
                final isSelected = _selectedPetType == pet.type;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPetType = pet.type;
                      _selectedBreed = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? pet.color : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: pet.accent.withAlpha(60),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          pet.icon,
                          size: 48,
                          color: pet.accent,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.type,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Virtual Wellbeings',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            /// === BREED ===
            _title('Ras atau jenis'),
            const SizedBox(height: 10),
            _dropdown<String>(
              value: _selectedBreed,
              hint: 'Pilih ras',
              items: _getAvailableBreeds(),
              onChanged: (val) => setState(() => _selectedBreed = val),
            ),

            const SizedBox(height: 24),

            /// === NAMA ===
            _title('Nama peliharaanmu'),
            const SizedBox(height: 10),
            TextField(
              onChanged: (val) => _selectedPetName = val,
              decoration: _inputDecoration('Nama'),
            ),

            const SizedBox(height: 24),

            /// === GENDER ===
            _title('Jenis kelamin peliharaanmu'),
            const SizedBox(height: 10),
            Row(
              children: [
                _genderButton('Jantan'),
                const SizedBox(width: 12),
                _genderButton('Betina'),
              ],
            ),

            const SizedBox(height: 24),

            /// === UMUR ===
            _title('Umur peliharaanmu'),
            const SizedBox(height: 10),
            Row(
              children: [
                _ageDropdown('Bulan'),
                const SizedBox(width: 12),
                _ageDropdown('Tahun'),
              ],
            ),

            const SizedBox(height: 40),

            /// === SUBMIT ===
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA726),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Tambahkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== HELPERS ==================

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(e.toString()),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: _inputDecoration(hint),
    );
  }

  Widget _genderButton(String gender) {
    final selected = _selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFA726) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              gender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ageDropdown(String unit) {
    final isMonth = unit == 'Bulan';
    final selected = isMonth ? _ageMonths : _ageYears;
    final options = List.generate(isMonth ? 12 : 30, (i) => i + 1);

    return Expanded(
      child: DropdownButtonFormField<int>(
        value: selected,
        hint: Text(unit),
        items: options
            .map((e) => DropdownMenuItem(value: e, child: Text('$e $unit')))
            .toList(),
        onChanged: (val) {
          setState(() {
            if (isMonth) {
              _ageMonths = val;
            } else {
              _ageYears = val;
            }
          });
        },
        decoration: _inputDecoration(unit),
      ),
    );
  }

  void _submit() {
    if (_selectedPetType == null ||
        _selectedBreed == null ||
        _selectedPetName == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi data terlebih dahulu')),
      );
      return;
    }

    Navigator.pop(context);
  }
}

/// === MODEL OPSI JENIS HEWAN ===
class _PetTypeOption {
  final String type;
  final IconData icon;
  final Color color;
  final Color accent;

  const _PetTypeOption({
    required this.type,
    required this.icon,
    required this.color,
    required this.accent,
  });
}
