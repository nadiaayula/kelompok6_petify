import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet_model.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.pet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8F0),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Pet image + action buttons
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        pet.imageUrl,
                        fit: BoxFit.contain,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Column(
                        children: [
                          _cardActionIcon(Icons.favorite_border),
                          const SizedBox(height: 12),
                          _cardActionIcon(Icons.auto_fix_high),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Pet info section
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.type,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.name.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _infoItem(Icons.cake_outlined, 'Umur', pet.age)),
                        const SizedBox(width: 16),
                        Expanded(child: _infoItem(Icons.monitor_weight_outlined, 'Berat', pet.weight)),
                        const SizedBox(width: 16),
                        Expanded(child: _infoItem(Icons.transgender, 'Kelamin', pet.gender)),
                        const SizedBox(width: 16),
                        Expanded(child: _infoItem(Icons.pets, 'Ras', pet.breed)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardActionIcon(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.grey[400], size: 24),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.orange,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}