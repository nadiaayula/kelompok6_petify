import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. PET MODEL
class Pet {
  final String id;
  final String name;
  final String type;
  final String age;
  final String imageUrl;

  Pet({
    required this.id, 
    required this.name, 
    required this.type, 
    required this.age, 
    required this.imageUrl
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 2. YOUR PET DATA (Vinc, Bolu, etc.)
  final List<Pet> pets = [
    Pet(
      id: '1',
      name: "Vinc",
      type: "Kucing",
      age: "6 Bulan",
      imageUrl: "assets/kucing1.png", 
    ),
    Pet(
      id: '2',
      name: "Bolu",
      type: "Kucing", 
      age: "1 Tahun",
      imageUrl: "assets/kucing2.png",
    ),
    Pet(
      id: '3',
      name: "Beta",
      type: "Kucing",
      age: "8 Bulan", 
      imageUrl: "assets/anjing1.png",
    ),
    Pet(
      id: '4',
      name: "Kosmin",
      type: "Kucing",
      age: "2 Tahun",
      imageUrl: "assets/kucing3.png",
    )
  ];

  // Controller for the carousel
  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey[200],
              backgroundImage: const NetworkImage("https://placehold.co/100x100/png?text=A"),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, Anya!",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Malang, Jawa Timur",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF707070),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF707070)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- POINTS CARD ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: _buildPointsCard(),
            ),
            const SizedBox(height: 24),
            
            // --- VIRTUAL PET CAROUSEL SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Virtual Pet Wellbeings",
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Tingkatkan kepedulian dengan peliharaanmu",
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 3. THE CAROUSEL WIDGET
            SizedBox(
              height: 320, // Height of the carousel area
              child: PageView.builder(
                controller: _pageController,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0), // Spacing between cards
                    child: _buildPetWellbeingCard(pets[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // --- CHECKPOINTS SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Checkpoints",
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCheckpointItem(
                    "Makan",
                    "Terakhir hari ini 10.15 AM",
                    Icons.food_bank_outlined,
                    const Color(0xFFF9E7D8),
                    Colors.orange,
                  ),
                  _buildCheckpointItem(
                    "Mandi",
                    "Terakhir Kemarin 16 April 2024",
                    Icons.shower_outlined,
                    const Color(0xFFFAE0E4),
                    Colors.pink,
                  ),
                  _buildCheckpointItem(
                    "Vaksinasi",
                    "Terakhir Rabu 12 April 2024",
                    Icons.medical_services_outlined,
                    const Color(0xFFF9E7D8),
                    Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  
                  // --- REWARDS SECTION ---
                  Text(
                    "Rewards Point",
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Tukar poin dengan reward yang kamu mau!",
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildRewardsList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS (Required for build method) ---

  Widget _buildPointsCard() {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9F1C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9F1C).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1.500",
                    style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  Text(
                    "Points",
                    style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                 width: 40, height: 40,
                 decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                 child: IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.white, size: 20)),
              ),
              const SizedBox(width: 8),
              Container(
                 width: 40, height: 40,
                 decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                 child: IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPetWellbeingCard(Pet pet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              pet.imageUrl, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text("Asset not found:\n${pet.imageUrl}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pet.name, 
            style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          Text(
            "${pet.type} • ${pet.age}", 
            style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey)
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[100]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pengingat", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text("Apabila \"${pet.name}\" butuh vaksin", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Switch(
                value: true, 
                onChanged: (val) {}, 
                activeColor: const Color(0xFFFF9F1C),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCheckpointItem(String title, String subtitle, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList() {
    final rewards = [
      {"name": "Mainan", "icon": Icons.toys_outlined, "color": const Color(0xFFFEE7E6)},
      {"name": "Makanan", "icon": Icons.lunch_dining_outlined, "color": const Color(0xFFD3F8D3)},
      {"name": "Minum", "icon": Icons.water_drop_outlined, "color": const Color(0xFFD2EFFD)},
      {"name": "Pasir", "icon": Icons.grass_outlined, "color": const Color(0xFFFEE7F6)},
    ];

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rewards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  color: rewards[index]["color"] as Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(rewards[index]["icon"] as IconData, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(rewards[index]["name"] as String, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[700])),
            ],
          );
        },
      ),
    );
  }

}