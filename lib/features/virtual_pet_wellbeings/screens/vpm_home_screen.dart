import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pet_model.dart';
import '../widgets/pet_card.dart';
import '../screens/add_pet_screen.dart';

class VpmHomeScreen extends StatefulWidget {
  const VpmHomeScreen({super.key});

  @override
  State<VpmHomeScreen> createState() => _VpmHomeScreenState();
}

class _VpmHomeScreenState extends State<VpmHomeScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  static const List<Pet> pets = [
    Pet(
      id: '1',
      name: "Vinc",
      type: "Kucing",
      age: "6 Bulan",
      weight: "2.5 Kg",
      gender: "Betina",
      breed: "Angora",
      imageUrl: "assets/images/kucing1.png",
    ),
    Pet(
      id: '2',
      name: "Bolu",
      type: "Kucing",
      age: "1 Tahun",
      weight: "3.2 Kg",
      gender: "Jantan",
      breed: "Persian",
      imageUrl: "assets/cat2.png",
    ),
    Pet(
      id: '3',
      name: "Beta",
      type: "Kucing",
      age: "8 Bulan",
      weight: "2.8 Kg",
      gender: "Betina",
      breed: "Siamese",
      imageUrl: "assets/cat3.png",
    ),
    Pet(
      id: '4',
      name: "Kosmin",
      type: "Kucing",
      age: "2 Tahun",
      weight: "4.1 Kg",
      gender: "Jantan",
      breed: "Maine Coon",
      imageUrl: "assets/cat4.png",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToAddPet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPetScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, // Memberikan ruang extra di bagian bawah
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
                  _squareIconButton(icon: Icons.menu, onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Title - Ukuran diperkecil sedikit agar hemat tempat
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
                      const Text('🐱', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      const Text('🐱', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      const Text('🐶', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text(
                        '${pets.length}+ Pet lainnya',
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

            // Bagian PageView (Kartu)
            Expanded(
              child: PageView.builder(
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

            // Navigator Bar (Indikator Dots + Tombol Panah)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Row(
                children: [
                  const SizedBox(width: 44), // Penyeimbang agar dots tetap di tengah
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

class _ArrowCircleButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ArrowCircleButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.arrow_forward_ios, color: Colors.grey[500], size: 20),
        ),
      ),
    );
  }
}
