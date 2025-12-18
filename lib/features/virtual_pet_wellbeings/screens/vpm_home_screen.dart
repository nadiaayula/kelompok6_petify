import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet_model.dart';
import '../widgets/pet_card.dart';
import '../screens/add_pet_screen.dart';
import '../../../common/widgets/shortcut_page.dart';

class VpmHomeScreen extends StatefulWidget {
  const VpmHomeScreen({super.key});

  @override
  State<VpmHomeScreen> createState() => _VpmHomeScreenState();
}

class _VpmHomeScreenState extends State<VpmHomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  
  // Variabel untuk menampung data dari Supabase
  List<Pet> pets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPets(); 
  }

  // FUNGSI AMBIL DATA DARI SUPABASE
  Future<void> _fetchPets() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final response = await Supabase.instance.client
          .from('pets')
          .select()
          .eq('owner_id', user.id) 
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      
      setState(() {
        pets = data.map((json) => Pet.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // FUNGSI NAVIGASI + REFRESH OTOMATIS
  void _goToAddPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPetScreen()),
    );
    if (result == true) {
      _fetchPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _squareIconButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.pets, color: Colors.orange, size: 36),
                  _squareIconButton(
                    icon: Icons.menu, 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShortcutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Virtual Pet\nWellbeings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.1,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pet Icons & Add Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (pets.isNotEmpty)
                        SizedBox(
                          height: 32,
                          width: (pets.length > 3 ? 3 : pets.length) * 22.0 + 10, 
                          child: Stack(
                            clipBehavior: Clip.none, 
                            children: List.generate(
                              pets.length > 3 ? 3 : pets.length,
                              (index) => Positioned(
                                left: index * 20.0, 
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.grey[100],
                                    backgroundImage: AssetImage(
                                      pets[index].species == 'Kucing'
                                          ? (index % 2 == 0 ? 'assets/images/cat_avatar_1.png' : 'assets/images/cat_avatar_2.png')
                                          : 'assets/images/dog_avatar_1.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      const SizedBox(width: 8),

                      Text(
                        pets.length <= 3 
                            ? 'Total ${pets.length} Pet' 
                            : '${pets.length - 3}+ Pet lainnya',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  _circleAddButton(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Konten Utama: Loading atau PageView
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : pets.isEmpty 
                  ? Center(
                      child: Text(
                        "Belum ada data peliharaan.\nKlik tombol + untuk menambah.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                      ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: PetCard(
                            pet: pets[index],
                            onTap: () {}, 
                          ),
                        );
                      },
                    ),
            ),

            // Navigator Bar
            if (!_isLoading && pets.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Row(
                  children: [
                    const SizedBox(width: 44),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pets.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _currentPage ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: index == _currentPage ? Colors.orange : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _smallArrowButton(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _smallArrowButton() {
    return GestureDetector(
      onTap: () {
        if (_currentPage < pets.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
      ),
    );
  }

  Widget _circleAddButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.orange, size: 24),
        onPressed: _goToAddPet,
      ),
    );
  }

  Widget _squareIconButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.grey[400], size: 18),
        onPressed: onTap,
      ),
    );
  }
}