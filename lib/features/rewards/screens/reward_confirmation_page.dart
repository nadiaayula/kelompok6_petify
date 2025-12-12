import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'reward_status_dialog.dart';

class RewardConfirmationPage extends StatefulWidget {
  final String rewardId;
  final String rewardName;
  final String rewardPoints;
  final String? imageUrl;

  const RewardConfirmationPage({
    Key? key,
    required this.rewardId,
    required this.rewardName,
    required this.rewardPoints,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<RewardConfirmationPage> createState() => _RewardConfirmationPageState();
}

class _RewardConfirmationPageState extends State<RewardConfirmationPage> {
  final supabase = Supabase.instance.client;
  
  bool isAutoFill = false;
  String selectedShipping = '';
  bool isConfirmed = false;
  bool isSubmitting = false;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }
  
  Future<void> _loadProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;
      
      final result = await supabase.rpc('get_user_profile_for_redemption', params: {
        'p_user_id': userId,
      });
      
      if (result != null && result is Map) {
        setState(() {
          nameController.text = result['display_name'] ?? '';
          phoneController.text = result['phone'] ?? '';
          addressController.text = result['address'] ?? '';
          provinceController.text = result['province'] ?? '';
          postalCodeController.text = result['postal_code'] ?? '';
          emailController.text = supabase.auth.currentUser?.email ?? '';
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }
  
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      print('❌ Validation failed: Name empty');
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      print('❌ Validation failed: Phone empty');
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      print('❌ Validation failed: Email empty');
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      print('❌ Validation failed: Address empty');
      return false;
    }
    if (provinceController.text.trim().isEmpty) {
      print('❌ Validation failed: Province empty');
      return false;
    }
    if (postalCodeController.text.trim().isEmpty) {
      print('❌ Validation failed: Postal code empty');
      return false;
    }
    if (selectedShipping.isEmpty) {
      print('❌ Validation failed: Shipping not selected');
      return false;
    }
    if (!isConfirmed) {
      print('❌ Validation failed: Not confirmed');
      return false;
    }
    print('✅ Validation passed');
    return true;
  }

  Future<void> _handleSubmit() async {
    print('🔵 Submit button pressed');
    
    if (!_validateForm()) {
      print('❌ Form validation failed');
      // Langsung show dialog gagal, BUKAN SnackBar
      RewardStatusDialog.show(context, isSuccess: false);
      return;
    }
    
    setState(() => isSubmitting = true);
    
    try {
      final userId = supabase.auth.currentUser?.id;
      print('👤 User ID: $userId');
      
      if (userId == null) {
        throw Exception('User not logged in');
      }
      
      final fullAddress = '${addressController.text}, ${provinceController.text}, ${postalCodeController.text}';
      
      print('📤 Sending to Supabase:');
      print('  - User ID: $userId');
      print('  - Reward ID: ${widget.rewardId}');
      print('  - Name: ${nameController.text.trim()}');
      print('  - Phone: ${phoneController.text.trim()}');
      print('  - Address: $fullAddress');
      print('  - Shipping: ${selectedShipping.toLowerCase()}');
      
      // Map shipping name ke format yang diterima database
      String shippingCode = selectedShipping.toLowerCase();
      if (selectedShipping == 'J&T') {
        shippingCode = 'jnt';
      } else if (selectedShipping == 'JNE') {
        shippingCode = 'jne';
      } else if (selectedShipping == 'SiCepat') {
        shippingCode = 'sicepat';
      } else if (selectedShipping == 'Anteraja') {
        shippingCode = 'anteraja';
      }
      
      print('  - Shipping: ${selectedShipping} → $shippingCode');
      
      final result = await supabase.rpc('manual_redeem_reward', params: {
        'p_user_id': userId,
        'p_reward_id': widget.rewardId,
        'p_recipient_name': nameController.text.trim(),
        'p_recipient_phone': phoneController.text.trim(),
        'p_address': fullAddress,
        'p_shipping_provider': shippingCode,
      });
      
      print('📥 Response received:');
      print('  - Type: ${result.runtimeType}');
      print('  - Value: $result');
      
      setState(() => isSubmitting = false);
      
      // Handle berbagai format response
      bool isSuccess = false;
      
      if (result == null) {
        print('✅ Result is null - treating as success');
        isSuccess = true;
      } else if (result is bool) {
        print('✅ Result is bool: $result');
        isSuccess = result;
      } else if (result is Map) {
        print('✅ Result is Map: $result');
        isSuccess = result['success'] == true;
      } else if (result is String) {
        print('✅ Result is String: $result');
        isSuccess = result.toLowerCase() == 'success';
      } else {
        print('⚠️ Unknown result type: ${result.runtimeType}');
      }
      
      print('🎯 Final isSuccess: $isSuccess');
      
      if (!mounted) return;
      RewardStatusDialog.show(context, isSuccess: isSuccess);
      
    } catch (e, stackTrace) {
      print('💥 ERROR caught:');
      print('  Error: $e');
      print('  Stack trace: $stackTrace');
      
      setState(() => isSubmitting = false);
      
      if (!mounted) return;
      RewardStatusDialog.show(context, isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Konfirmasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halaman konfirmasi penukaran reward pointmu',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStep('Produk', true, true),
                  _buildLine(true),
                  _buildStep('Konfirmasi', true, false),
                  _buildLine(false),
                  _buildStep('Status', false, false),
                ],
              ),

              const SizedBox(height: 32),

              Center(
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[50]!, Colors.blue[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: widget.imageUrl != null
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            widget.imageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.pets, size: 100);
                            },
                          ),
                        )
                      : const Icon(Icons.pets, size: 100),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.diamond, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.rewardPoints,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Nama/ID',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildTextField('Nama lengkap', nameController),
              const SizedBox(height: 12),
              _buildPhoneField(),
              const SizedBox(height: 12),
              _buildTextField('E-mail', emailController),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Isi otomatis',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Data akan diisi dari profilmu',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Switch(
                    value: isAutoFill,
                    onChanged: (value) {
                      setState(() => isAutoFill = value);
                      if (value) _loadProfile();
                    },
                    activeColor: Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Alamat Penerima',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _buildAddressField(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTextField('Provinsi', provinceController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Kode pos', postalCodeController)),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'Ekspedisi Pengiriman',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildShippingOption('Anteraja', 'assets/images/anteraja.png')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShippingOption('JNE', 'assets/images/jne.png')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildShippingOption('J&T', 'assets/images/jnt.png')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShippingOption('SiCepat', 'assets/images/sicepat.png')),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Semua data yang dimasukkan adalah informasi yang benar dan sesuai dengan ketentuan',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Switch(
                    value: isConfirmed,
                    onChanged: (value) {
                      setState(() => isConfirmed = value);
                    },
                    activeColor: Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Lanjutkan',
                            style: TextStyle(color: Colors.white),
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String label, bool isActive, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.orange : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.orange : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 30),
      color: isActive ? Colors.orange : Colors.grey[300],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [Colors.red, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Nomor telepon',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: 'Alamat',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          const Icon(Icons.location_on, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildShippingOption(String name, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedShipping = name);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedShipping == name ? Colors.orange : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}