import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kelompok6_adoptify/owner_profile/profile_page.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/medical_record_screen.dart';
import 'package:kelompok6_adoptify/features/rewards/screens/rewards_page.dart';

// =============================
// 1. PET MODEL
// =============================
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
    required this.imageUrl,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // =============================
  // 2. PET DATA
  // =============================
  final List<Pet> pets = [
    Pet(id: '1', name: "Vinc", type: "Kucing", age: "6 Bulan", imageUrl: "assets/images/kucing1.png"),
    Pet(id: '2', name: "Bolu", type: "Kucing", age: "1 Tahun", imageUrl: "assets/images/kucing2.png"),
    Pet(id: '3', name: "Beta", type: "Kucing", age: "8 Bulan", imageUrl: "assets/images/anjing1.png"),
    Pet(id: '4', name: "Kosmin", type: "Kucing", age: "2 Tahun", imageUrl: "assets/images/kucing3.png"),
  ];

  // =============================
  // 3. CONTROLLERS
  // =============================
  final PageController _pageController = PageController(viewportFraction: 0.9);

  // =============================
  // 4. USER PROFILE DATA
  // =============================
  String userName = "Loading...";
  String userProvince = "Loading...";
  String? userAvatar;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // =============================
  // 5. FETCH DATA DARI SUPABASE
  // =============================
  Future<void> fetchProfileData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await Supabase.instance.client
        .from('owner_profile')
        .select()
        .eq('user_id', user.id)
        .single();

    setState(() {
      userName = data['display_name'] ?? "User";
      userProvince = data['province'] ?? "Tidak ada lokasi";
      userAvatar = data['avatar_url'];
    });
  }

  // =============================
  // 6. UI STARTS HERE
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // =============================
              // PROFILE CARD
              // =============================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (userAvatar != null && userAvatar!.isNotEmpty)
                            ? NetworkImage(userAvatar!)
                            : const NetworkImage("https://placehold.co/100/png?text=P"),
                      ),
                      const SizedBox(width: 15),

                      // Nama + Provinsi
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo, $userName!",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff202020),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: Color(0xff828282),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                userProvince,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: const Color(0xff828282),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // =============================
              // POINTS CARD
              // =============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: _buildPointsCard(),
              ),

              const SizedBox(height: 24),

              // =============================
              // VIRTUAL PET SECTION
              // =============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Virtual Pet Wellbeings",
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      "Tingkatkan kepedulian dengan peliharaanmu",
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: _buildPetWellbeingCard(pets[index]),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // =============================
              // CHECKPOINTS
              // =============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MedicalRecordScreen()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Image.asset(
                          'assets/images/dashboardmedical.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ),

                    Text(
                      "Checkpoints",
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.bold),
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

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RewardsPage()),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rewards Point",
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Tukar poin dengan reward yang kamu mau!",
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
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
      ),
    );
  }

  // =============================
  // HELPER WIDGETS
  // =============================

  Widget _buildPointsCard() {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9F1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("1.500",
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text("Points",
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9))),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                ),
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
      ),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              pet.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 16),
          Text(pet.name,
              style:
                  GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("${pet.type} • ${pet.age}",
              style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCheckpointItem(String title, String subtitle, IconData icon,
      Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                Text(title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
              ],
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: rewards[index]["color"] as Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  rewards[index]["icon"] as IconData,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                rewards[index]["name"] as String,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          );
        },
      ),
    );
  }
}
