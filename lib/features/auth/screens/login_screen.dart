import 'package:flutter/material.dart';
import 'package:kelompok6_adoptify/features/auth/screens/register_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final email = _emailController.text;
        final password = _passwordController.text;
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
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

  void _handleForgotPassword() {
    // Navigasi ke halaman lupa kata sandi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur lupa kata sandi')),
    );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login dengan $provider')),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/kucing1.png'), // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () {
                        // Tampilkan informasi
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(),
              ),

              // Bottom Sheet
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // Input E-mail
                          _buildTextField(
                            controller: _emailController,
                            icon: Icons.person_outline,
                            hintText: 'E-mail',
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
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          // Lupa Kata Sandi
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _handleForgotPassword,
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Tombol Masuk
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
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
                                    'Masuk',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Belum punya akun?'),
                              TextButton(
                                onPressed: _navigateToRegister,
                                child: const Text('Daftar'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Atau Lanjutkan Dengan
                          const Text(
                            'atau lanjutkan dengan',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                icon: Icons.facebook,
                                color: const Color(0xFF1877F2),
                                onTap: () => _handleSocialLogin('Meta'),
                              ),
                              const SizedBox(width: 20),
                              _buildSocialButton(
                                icon: Icons.phone,
                                color: const Color(0xFF25D366),
                                onTap: () => _handleSocialLogin('WhatsApp'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildSocialButton({
    IconData? icon,
    String? iconPath,
    Color? color,
    Color? backgroundColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: backgroundColor ?? color?.withOpacity(0.1) ?? Colors.white,
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: color, size: 30)
              : iconPath != null
                  ? Image.asset(iconPath, width: 30, height: 30)
                  : const SizedBox(),
        ),
      ),
    );
  }
}
