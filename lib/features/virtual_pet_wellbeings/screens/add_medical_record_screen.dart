import 'package:flutter/material.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  const AddMedicalRecordScreen({Key? key}) : super(key: key);

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  bool _autoFill = false;
  String _selectedCountryCode = '🇮🇩';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // ubah dari 0xFFFAFAFA ke 0xFFF8F8F8
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // tambahkan tinggi AppBar
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // ubah ke spaceBetween
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
              
              // TITLE - ubah jadi Flexible
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
              
              // MENU BUTTON
              Container(
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
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Data Pemilik Section
          const Text(
            'Data Pemilik',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          
          _buildTextField(hint: 'Nama lengkap'),
          const SizedBox(height: 12),
          
          _buildPhoneField(),
          const SizedBox(height: 12),
          
          _buildTextField(hint: 'E-mail'),
          const SizedBox(height: 20),
          
          // Isi Otomatis Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Isi otomatis',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Data akan diisi dari profilmu',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _autoFill,
                  onChanged: (value) {
                    setState(() {
                      _autoFill = value;
                    });
                  },
                  activeColor: const Color(0xFFFFA726),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          
          // Data Peliharaan Section
          const Text(
            'Data Peliharaan',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          
          _buildTextField(hint: 'Nama peliharaan'),
          const SizedBox(height: 12),
          
          _buildTextField(hint: 'Kondisi kesehatan'),
          const SizedBox(height: 12),
          
          _buildTextField(
            hint: 'Deskripsi riwayat kesehatan',
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildTextField(hint: 'Berat peliharaan'),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          
          _buildTextField(hint: 'Nama Klinik'),
          const SizedBox(height: 12),
          
          _buildTextField(hint: 'Nama dokter atau perawat'),
          const SizedBox(height: 12),
          
          _buildTextField(
            hint: 'Alamat klinik',
            suffixIcon: const Icon(
              Icons.location_on,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.calendar_today,
                  label: _selectedDate == null 
                    ? 'Tanggal' 
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.image_outlined,
                  label: 'X-Ray',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          _buildTextField(
            hint: 'Catatan medis',
            maxLines: 3,
          ),
          const SizedBox(height: 30),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // tetap putih untuk field
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFB7B7B7), // ubah warna font ke B7B7B7
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFB7B7B7), // ubah hint color ke B7B7B7
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

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // tetap putih
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  _selectedCountryCode,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFFB7B7B7), // ubah ke B7B7B7
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFB7B7B7), // ubah ke B7B7B7
              ),
              decoration: InputDecoration(
                hintText: 'Nomor telepon',
                hintStyle: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFB7B7B7), // ubah ke B7B7B7
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6B6B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}