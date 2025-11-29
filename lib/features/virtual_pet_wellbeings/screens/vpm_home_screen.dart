import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../rewards/screens/rewards_page.dart';
import '../widgets/pet_card.dart';
import '../models/pet_model.dart';

class VpmHomeScreen extends StatelessWidget {
  static const List<Pet> pets = [
    const Pet(
      id: '1',
      name: "Vinc",
      type: "Kucing",
      age: "6 Bulan",
      weight: "2.5 Kg",
      gender: "Betina",
      breed: "Angora",
      imageUrl: "assets/cat1.png",
    ),
    const Pet(
      id: '2',
      name: "Bolu",
      type: "Kucing", 
      age: "1 Tahun",
      weight: "3.2 Kg",
      gender: "Jantan",
      breed: "Persian",
      imageUrl: "assets/cat2.png",
    ),
    const Pet(
      id: '3',
      name: "Beta",
      type: "Kucing",
      age: "8 Bulan", 
      weight: "2.8 Kg",
      gender: "Betina",
      breed: "Siamese",
      imageUrl: "assets/cat3.png",
    ),
    const Pet(
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

  const VpmHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {},
                  ),
                  Text(
                    'VirtualPet',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.card_giftcard, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RewardsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Wellbeings Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Wellbeings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            
            // Pet Count
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '${pets.length}+ Pet lainnya',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            // Pet Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return PetCard(
                    pet: pets[index],
                    onTap: () {
                      // Akan diisi nanti untuk navigation ke detail
                      print('Tapped on ${pets[index].name}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Akan diisi nanti untuk tambah pet baru
          print('Add new pet');
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}