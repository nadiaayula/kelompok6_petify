import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final email = _emailController.text;
        final password = _passwordController.text;
        final name = _nameController.text;
        final whatsapp = _whatsappController.text;

        // Sign up user
        print('🔍 Starting signup for: $email');
        
        try {
          final response = await Supabase.instance.client.auth.signUp(
            email: email,
            password: password,
          );
          
          print('🔍 Signup response: ${response.user?.id}');
          print('🔍 Session: ${response.session?.accessToken != null ? "Valid" : "Null"}');

          // Insert ke tabel owner_profile
          if (response.user != null) {
            try {
              print('🔍 DEBUG: Trying to insert profile...');
              print('🔍 User ID: ${response.user!.id}');
              print('🔍 Display Name: $name');
              print('🔍 Phone: $whatsapp');
              
              await Supabase.instance.client.from('owner_profile').insert({
                'user_id': response.user!.id,
                'display_name': name,
                'phone': whatsapp,
              });
              print('✅ Profile saved successfully');
            } catch (e) {
              print('❌ Error saving profile: $e');
              print('❌ Error type: ${e.runtimeType}');
              // Show detailed error to user
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Warning: Profile not saved. Error: $e'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            }
          } else {
            print('⚠️ No user returned from signup');
          }
        } catch (signupError) {
          print('❌❌ SIGNUP FAILED: $signupError');
          print('❌❌ Error type: ${signupError.runtimeType}');
          rethrow; // Throw lagi biar ketangkap di catch utama
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Check your email for confirmation.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } on AuthException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('An unexpected error occurred'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.grey),
            onPressed: () {
              // Tampilkan informasi
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Buat akun',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Input Nama Pengguna
                  _buildTextField(
                    controller: _nameController,
                    icon: Icons.person_outline,
                    hintText: 'Nama pengguna',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama pengguna harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Input E-mail
                  _buildTextField(
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    hintText: 'E-mail',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-mail harus diisi';
                      }
                      if (!value.contains('@')) {
                                              return 'E-mail tidak valid';
                                            }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Input No. WhatsApp
                  _buildTextField(
                    controller: _whatsappController,
                    icon: Icons.phone,
                    hintText: 'No. WhatsApp',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor WhatsApp harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Input Kata Sandi
                  _buildTextField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    hintText: 'Kata sandi',
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi harus diisi';
                      }
                      if (value.length < 6) {
                        return 'Kata sandi minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Input Ulangi Kata Sandi
                  _buildTextField(
                    controller: _confirmPasswordController,
                    icon: Icons.lock_outline,
                    hintText: 'Ulangi kata sandi',
                    obscureText: !_isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi kata sandi harus diisi';
                      }
                      if (value != _passwordController.text) {
                        return 'Kata sandi tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Tombol Daftar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 30),

                  // Link ke Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah memiliki akun? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
