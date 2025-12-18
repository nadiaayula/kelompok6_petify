import 'package:flutter/material.dart';

class JenisVaksinasiModal extends StatefulWidget {
  const JenisVaksinasiModal({Key? key}) : super(key: key);

  @override
  State<JenisVaksinasiModal> createState() => _JenisVaksinasiModalState();
}

class _JenisVaksinasiModalState extends State<JenisVaksinasiModal> {
  Map<String, String>? _selectedVaksinInfo;

  // Data vaksin
  final List<Map<String, dynamic>> _vaksinData = [
    {
      'category': 'Vaksin Anjing',
      'icon': '💉',
      'vaccines': [
        'Distemper',
        'Parvovirus',
        'Hepatitis',
        'Rabies',
        'Leptospira',
        'Parainfluenza',
        'Bordetella',
      ],
    },
    {
      'category': 'Vaksin Kucing',
      'icon': '💉',
      'vaccines': [
        'Feline viral rhinotracheitis',
        'Feline calicivirus',
        'Feline panleukopenia',
        'Rabies',
        'Feline chlamydiosis',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'JENIS VAKSINASI',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          
          // Scrollable content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _vaksinData.length,
              itemBuilder: (context, categoryIndex) {
                final category = _vaksinData[categoryIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Text(
                            category['icon'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['category'],
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF6B6B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Vaccine list
                    ...List.generate(
                      category['vaccines'].length,
                      (vaccineIndex) {
                        final vaccine = category['vaccines'][vaccineIndex];
                        final isSelected = _selectedVaksinInfo?['name'] == vaccine;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: RadioListTile<String>(
                            value: vaccine,
                            groupValue: _selectedVaksinInfo?['name'],
                            onChanged: (value) {
                              setState(() {
                                _selectedVaksinInfo = {
                                  'name': value!,
                                  'category': category['category']
                                };
                              });
                            },
                            title: Text(
                              vaccine,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: isSelected ? Colors.black : Colors.black87,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            activeColor: const Color(0xFFFF6B6B),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
          
          // Bottom button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedVaksinInfo != null) {
                    Navigator.pop(context, _selectedVaksinInfo);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
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
          ),
        ],
      ),
    );
  }
}

// Fungsi helper untuk menampilkan modal
void showJenisVaksinasiModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const JenisVaksinasiModal(),
  );
}
