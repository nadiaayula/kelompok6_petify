import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet_model.dart';

class PetCard extends StatefulWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.pet,
    this.onTap,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    String petIcon = widget.pet.type == 'Kucing' 
        ? 'assets/images/icon_cat_main.png' 
        : 'assets/images/icon_dog_main.png';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white, // Background putih utama
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 1. ORNAMEN KUNING (bg_card tanpa background putih)
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg_card.png',
                  fit: BoxFit.cover,
                ),
              ),

              // 2. ICON HEWAN (Lebih kecil dan posisi pas)
              Positioned(
                left: -10,
                bottom: 60,
                child: Image.asset(
                  petIcon,
                  height: 200, // Ukuran diperkecil agar lebih clean
                  fit: BoxFit.contain,
                ),
              ),

              // 3. ACTION ICONS (Love & Magic Wand)
              Positioned(
                top: 20,
                right: 20,
                child: Row(
                  children: [
                    _actionIcon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      isFavorite ? Colors.red : Colors.grey[300]!,
                      () => setState(() => isFavorite = !isFavorite),
                    ),
                    const SizedBox(width: 10),
                    _actionIcon(Icons.auto_fix_high, Colors.grey[300]!, () {}),
                  ],
                ),
              ),

              // 4. NAMA & TIPE (Rata Kiri di sisi kanan kartu)
              Positioned(
                right: 35,
                top: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Rata Kiri
                  children: [
                    Text(
                      widget.pet.type,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      widget.pet.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              // 5. INFO SECTION MINIMALIS (Tanpa box putih)
              Positioned(
                bottom: 25,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoText(Icons.cake_outlined, 'Umur', widget.pet.age),
                    _infoText(Icons.monitor_weight_outlined, 'Berat', widget.pet.weight),
                    _infoText(Icons.transgender, 'Kelamin', widget.pet.gender),
                    _infoText(Icons.pets_outlined, 'Ras', widget.pet.breed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.9),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _infoText(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Info Rata Kiri
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.orange[700],
          ),
        ),
      ],
    );
  }
}