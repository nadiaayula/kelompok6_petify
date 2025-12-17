import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// FIX: Corrected the import from 'profile.dart' to 'profile_page.dart'
import 'package:kelompok6_adoptify/owner_profile/profile.dart'; 
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/medical_record_screen.dart';
// FIX: Removed 'screens/' from the path based on your directory
import 'package:kelompok6_adoptify/features/history/history_page.dart';

// =============================
// 1. PET MODEL (MATCHING SUPABASE SCHEMA)
// =============================
class Pet {
  final String id;
  final String name;
  final String type;   // Mapped from 'species'
  final String breed;  // From 'breed'
  final String gender; // From 'gender'
  final String age;    // Calculated from 'birth_date'
  final String weight; // From 'weight_kg'
  final String imageUrl;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weight,
    required this.imageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    // 1. Map Species
    String mapSpecies(String? species) {
      if (species == 'cat') return 'Kucing';
      if (species == 'dog') return 'Anjing';
      return species ?? 'Unknown';
    }

    // 2. Map Gender
    String mapGender(String? gender) {
      if (gender == 'male') return 'Jantan';
      if (gender == 'female') return 'Betina';
      return gender ?? '-';
    }

    // 3. Calculate Age from birth_date
    String calculateAge(String? birthDateString) {
      if (birthDateString == null) return "Umur -";
      try {
        final birthDate = DateTime.parse(birthDateString);
        final now = DateTime.now();
        final difference = now.difference(birthDate);
        final days = difference.inDays;

        if (days < 30) {
          return "$days Hari";
        } else if (days < 365) {
          final months = (days / 30).floor();
          return "$months Bulan";
        } else {
          final years = (days / 365).floor();
          return "$years Tahun";
        }
      } catch (e) {
        return "Umur -";
      }
    }

    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Tanpa Nama',
      type: mapSpecies(json['species']),
      breed: json['breed'] ?? '-',
      gender: mapGender(json['gender']),
      age: calculateAge(json['birth_date']), 
      weight: json['weight_kg'] != null ? "${json['weight_kg']} Kg" : "-",
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late Future<List<Pet>> _petsFuture;

  // State Variables for User Profile
  String userName = "Loading...";
  String userProvince = "Loading...";
  String? userAvatar;
  int userPoints = 0; 

  @override
  void initState() {
    super.initState();
    fetchUserData(); 
    _petsFuture = _fetchPets();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // =============================
  // 3. FETCH DATA LOGIC
  // =============================
  
  Future<void> fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // 1. Fetch Profile (Matches table 'owner_profiles')
      final profileResponse = await Supabase.instance.client
          .from('owner_profiles') 
          .select()
          .eq('id', user.id) 
          .maybeSingle(); 

      // 2. Fetch Points (Matches table 'user_points')
      final pointsResponse = await Supabase.instance.client
          .from('user_points')
          .select('total_points')
          .eq('user_id', user.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          if (profileResponse != null) {
            userName = profileResponse['full_name'] ?? "User";
            // Assuming 'province' column exists, otherwise use 'city_address'
            userProvince = profileResponse['province'] ?? profileResponse['city_address'] ?? "Indonesia";
            userAvatar = profileResponse['avatar_url'];
          }
          
          if (pointsResponse != null) {
            userPoints = pointsResponse['total_points'] ?? 0;
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<List<Pet>> _fetchPets() async {
    try {
      final supabase = Supabase.instance.client;
      // Fetch all columns needed for the updated Model
      final response = await supabase
          .from('pets')
          .select('id, name, species, breed, gender, birth_date, weight_kg, image_url');
      
      final data = response as List<dynamic>;
      return data.map((json) => Pet.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error fetching pets: $e");
      return [];
    }
  }

  // =============================
  // 4. UI STARTS HERE
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- PROFILE HEADER ---
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (userAvatar != null && userAvatar!.isNotEmpty)
                            ? NetworkImage(userAvatar!)
                            : const NetworkImage("https://placehold.co/100/png?text=P"),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Halo, $userName!", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xff202020))),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.location_on_outlined, size: 15, color: Color(0xff828282)), const SizedBox(width: 4), Text(userProvince, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xff828282)))]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --- POINTS CARD ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: _buildPointsCard(),
              ),

              const SizedBox(height: 24),

              // --- VIRTUAL PET TITLE (Left Aligned) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text(
                        "Virtual Pet Wellbeings", 
                        textAlign: TextAlign.start,
                        style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        "Tingkatkan kepedulian dengan peliharaanmu", 
                        textAlign: TextAlign.start,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- PET CAROUSEL / EMPTY STATE ---
              FutureBuilder<List<Pet>>(
                future: _petsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator(color: Colors.orange)),
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: Text("Gagal memuat data.")),
                    );
                  }

                  // Empty State (New User)
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyPetState();
                  }

                  final pets = snapshot.data!;
                  return SizedBox(
                    height: 340,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: PetWellbeingCard(pet: pets[index]),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // --- MEDICAL RECORD BANNER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildMedicalRecordBanner(context), 
              ),

              const SizedBox(height: 24),

              // --- CHECKPOINTS ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Checkpoints", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildCheckpointItem("Makan", "Terakhir hari ini 10.15 AM", Icons.food_bank_outlined, const Color(0xFFF9E7D8), Colors.orange),
                    _buildCheckpointItem("Mandi", "Terakhir Kemarin 16 April 2024", Icons.shower_outlined, const Color(0xFFFAE0E4), Colors.pink),
                    _buildCheckpointItem("Vaksinasi", "Terakhir Rabu 12 April 2024", Icons.medical_services_outlined, const Color(0xFFF9E7D8), Colors.orange),
                    const SizedBox(height: 24),
                    Text("Rewards Point", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Tukar poin dengan reward yang kamu mau!", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
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

  Widget _buildEmptyPetState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pets, size: 40, color: Colors.orange),
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada hewan peliharaan",
            style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            "Tambahkan hewan peliharaanmu untuk mulai memantau kesehatannya!",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to Add Pet Screen logic here
              debugPrint("Tambah Hewan ditekan");
            },
            icon: const Icon(Icons.add, color: Colors.white, size: 20),
            label: Text(
              "Tambah Hewan",
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9F1C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MedicalRecordScreen()),
        );
      },
      child: Container(
        height: 70, 
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFF8A8A), 
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                "Medical Record",
                style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Positioned(
              left: 10, bottom: 0, top: 5, 
              child: Image.asset(
                'assets/images/anjing1.png', 
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.pets, color: Colors.white, size: 40),
              ),
            ),
            Positioned(
              right: 20, top: 0, bottom: 0,
              child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    String formattedPoints = userPoints.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HistoryPage(filter: HistoryFilter.all)),
        );
      },
      child: Container(
        height: 110, 
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9F1C), 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFFFF9F1C).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10), 
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(12)), 
                child: const Icon(Icons.diamond_outlined, color: Colors.white, size: 30)
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text(formattedPoints, style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)), 
                  Text("Points", style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9)))
                ]
              )
            ]),
            Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.white, size: 20))),
              const SizedBox(width: 8),
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20)))
            ])
          ]
        ),
      ),
    );
  }

  Widget _buildCheckpointItem(String title, String subtitle, IconData icon, Color bgColor, Color iconColor) {
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: iconColor, size: 26)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey))]))]));
  }

  Widget _buildRewardsList() {
    final rewards = [
      {"name": "Mainan", "icon": Icons.toys_outlined, "color": const Color(0xFFFEE7E6)},
      {"name": "Makanan", "icon": Icons.lunch_dining_outlined, "color": const Color(0xFFD3F8D3)},
      {"name": "Minum", "icon": Icons.water_drop_outlined, "color": const Color(0xFFD2EFFD)},
      {"name": "Pasir", "icon": Icons.grass_outlined, "color": const Color(0xFFFEE7F6)},
    ];
    return SizedBox(height: 95, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: rewards.length, separatorBuilder: (_, __) => const SizedBox(width: 20), itemBuilder: (context, index) { return Column(children: [Container(width: 60, height: 60, decoration: BoxDecoration(color: rewards[index]["color"] as Color, shape: BoxShape.circle), child: Icon(rewards[index]["icon"] as IconData, color: Colors.black54)), const SizedBox(height: 8), Text(rewards[index]["name"] as String, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[700]))]);}));
  }
}

// --- PET CARD WIDGET ---
class PetWellbeingCard extends StatefulWidget {
  final Pet pet;
  const PetWellbeingCard({super.key, required this.pet});

  @override
  State<PetWellbeingCard> createState() => _PetWellbeingCardState();
}

class _PetWellbeingCardState extends State<PetWellbeingCard> {
  bool isReminderActive = true; 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              widget.pet.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                if (widget.pet.imageUrl.startsWith('assets/')) return Image.asset(widget.pet.imageUrl, fit: BoxFit.contain);
                return const Icon(Icons.pets, size: 80, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.pet.name, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text("${widget.pet.type} • ${widget.pet.age}", style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[100], thickness: 1),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Pengingat", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 2), Text("Apabila \"${widget.pet.name}\" butuh vaksin", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)])),
            Switch(value: isReminderActive, onChanged: (val) { setState(() { isReminderActive = val; }); }, activeColor: const Color(0xFFFF9F1C)),
          ])
        ],
      ),
    );
  }
}