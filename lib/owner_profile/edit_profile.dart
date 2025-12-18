import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../common/widgets/calendar_modal.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final supabase = Supabase.instance.client;

  bool isLoading = true;
  DateTime? birthDate;
  String selectedGender = 'male';
  String? avatarUrl;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _province = TextEditingController();
  final _postal = TextEditingController();
  final _birthDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('owner_profile')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data != null) {
      _name.text = data['display_name'] ?? '';
      _phone.text = data['phone'] ?? '';
      _address.text = data['address'] ?? '';
      _province.text = data['province'] ?? '';
      _postal.text = data['postal_code'] ?? '';
      selectedGender = data['gender'] ?? 'male';
      avatarUrl = data['avatar_url'];

      if (data['birth_date'] != null) {
        birthDate = DateTime.parse(data['birth_date']);
        _birthDateController.text =
            DateFormat('dd MMMM yyyy').format(birthDate!);
      }
    }

    _email.text = user.email ?? '';
    setState(() => isLoading = false);
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
          birthDate = date;
          _birthDateController.text = DateFormat('dd MMMM yyyy').format(date);
        });
      }
    });
  }

  // ================= ALERT + UPLOAD =================
  Future<void> _showUploadAlert() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Panduan Foto Profil'),
        content: const Text(
          'Gunakan foto dengan rasio 1:1 (persegi).\n'
          'Pastikan wajah berada di tengah agar foto tampil rapi.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickAndUploadAvatar();
            },
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    Uint8List? bytes;

    if (kIsWeb) {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (res == null || res.files.first.bytes == null) return;
      bytes = res.files.first.bytes!;
    } else {
      final picked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      bytes = await picked.readAsBytes();
    }

    final fileName =
        '${user.id}-${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('avatars').uploadBinary(
      fileName,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    final url = supabase.storage.from('avatars').getPublicUrl(fileName);

    await supabase
        .from('owner_profile')
        .update({'avatar_url': url}).eq('user_id', user.id);

    setState(() => avatarUrl = url);
  }

  // ================= SAVE =================
  Future<void> _save() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('owner_profile').update({
      'display_name': _name.text.trim(),
      'phone': _phone.text.trim(),
      'address': _address.text.trim(),
      'province': _province.text.trim(),
      'postal_code': _postal.text.trim(),
      'gender': selectedGender,
      'birth_date': birthDate?.toIso8601String().split('T').first,
    }).eq('user_id', user.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profil', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ===== AVATAR =====
                  Stack(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          image: avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: avatarUrl == null
                            ? const Center(
                                child: Text('🧑‍💼',
                                    style: TextStyle(fontSize: 40)),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: _showUploadAlert,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _field(_name, 'Nama Lengkap'),
                  _genderField(),
                  _dateField(),
                  _field(_phone, 'Nomor WhatsApp'),
                  _field(_email, 'Email', enabled: false),
                  _field(_address, 'Alamat rumah'),

                  Row(
                    children: [
                      Expanded(child: _field(_province, 'Provinsi')),
                      const SizedBox(width: 12),
                      Expanded(child: _field(_postal, 'Kode Pos')),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Simpan',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _birthDateController,
        readOnly: true,
        onTap: _showCalendarModal,
        decoration: InputDecoration(
          hintText: 'Tanggal Lahir',
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _genderField() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.grey[100], // background dropdown
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        dropdownColor: Colors.grey[100],
        items: const [
          DropdownMenuItem(
            value: 'male',
            child: Text('Laki-laki',
                style: TextStyle(color: Colors.black)),
          ),
          DropdownMenuItem(
            value: 'female',
            child: Text('Perempuan',
                style: TextStyle(color: Colors.black)),
          ),
        ],
        onChanged: (v) => setState(() => selectedGender = v!),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}
}
