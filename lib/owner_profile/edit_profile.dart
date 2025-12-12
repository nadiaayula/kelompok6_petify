import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final supabase = Supabase.instance.client;
  
  String selectedGender = 'male';
  bool isLoading = true;
  bool isSaving = false;
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);
    
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        setState(() => isLoading = false);
        return;
      }
      
      // Load profile from owner_profile table
      final response = await supabase
          .from('owner_profile')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (response != null) {
        setState(() {
          _nameController.text = response['display_name'] ?? '';
          _phoneController.text = response['phone'] ?? '';
          _addressController.text = response['address'] ?? '';
          _provinceController.text = response['province'] ?? '';
          _postalCodeController.text = response['postal_code'] ?? '';
          selectedGender = response['gender'] ?? 'male';
        });
      }
      
      // Load email from auth
      _emailController.text = supabase.auth.currentUser?.email ?? '';
      
      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    // Validasi
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama lengkap harus diisi')),
      );
      return;
    }
    
    setState(() => isSaving = true);
    
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');
      
      // Check if profile exists
      final existing = await supabase
          .from('owner_profile')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();
      
      final profileData = {
        'user_id': userId,
        'display_name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'province': _provinceController.text.trim(),
        'postal_code': _postalCodeController.text.trim(),
        'gender': selectedGender,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (existing != null) {
        // Update existing profile
        await supabase
            .from('owner_profile')
            .update(profileData)
            .eq('user_id', userId);
      } else {
        // Insert new profile
        profileData['created_at'] = DateTime.now().toIso8601String();
        await supabase.from('owner_profile').insert(profileData);
      }
      
      setState(() => isSaving = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true untuk refresh parent
      }
    } catch (e) {
      print('Error saving profile: $e');
      setState(() => isSaving = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan profil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                const SizedBox(height: 10),

                // ================= FOTO PROFILE =================
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 44,
                        child: Text('😀', style: TextStyle(fontSize: 40)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: pilih foto profile
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur upload foto segera hadir!')),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _Field(label: 'Nama lengkap', controller: _nameController),
                _GenderDropdown(
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() => selectedGender = value);
                  },
                ),
                _Field(label: 'Nomor WhatsApp', controller: _phoneController, keyboardType: TextInputType.phone),
                _Field(label: 'Email', controller: _emailController, enabled: false), // Email read-only
                _Field(label: 'Alamat rumah', controller: _addressController),

                Row(
                  children: [
                    Expanded(child: _Field(label: 'Provinsi', controller: _provinceController)),
                    const SizedBox(width: 12),
                    Expanded(child: _Field(label: 'Kode Pos', controller: _postalCodeController, keyboardType: TextInputType.number)),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
}

/* ================= FIELD ================= */

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool enabled;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: enabled ? const Color(0xFFF5F5F5) : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/* ================= GENDER DROPDOWN ================= */

class _GenderDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _GenderDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
          ),
        ),
      ),
    );
  }
}