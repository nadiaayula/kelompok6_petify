import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:kelompok6_adoptify/owner_profile/profile_page.dart'; 
import 'package:kelompok6_adoptify/features/medical_record/medical_record_screen.dart';
import 'package:kelompok6_adoptify/features/history/history_page.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/add_pet_screen.dart'; 
import 'package:kelompok6_adoptify/features/rewards/screens/rewards_page.dart';
import 'package:kelompok6_adoptify/features/rewards/screens/reward_confirmation_page.dart';
import 'package:kelompok6_adoptify/features/virtual_pet_wellbeings/screens/vpm_home_screen.dart';

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

  factory Pet.fromJson(Map<String, dynamic> json) {
    String mapSpecies(String? species) {
      if (species == 'cat' || species == 'Kucing') return 'Kucing';
      if (species == 'dog' || species == 'Anjing') return 'Anjing';
      return species ?? 'Unknown';
    }

    String displayAge = "6 Bulan"; 
    if (json['birth_date'] != null) {
      try {
        final birthDate = DateTime.parse(json['birth_date']);
        final days = DateTime.now().difference(birthDate).inDays;
        if (days > 365) {
          displayAge = "${(days / 365).floor()} Tahun";
        } else if (days > 30) {
          displayAge = "${(days / 30).floor()} Bulan";
        } else {
          displayAge = "$days Hari";
        }
      } catch (_) {}
    }

    return Pet(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Tanpa Nama',
      type: mapSpecies(json['species']),
      age: displayAge, 
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

  // State Variables
  String userName = "Loading...";
  String userProvince = "Loading...";
  String? userAvatar;
  int userPoints = 0; 
  
  // NEW: State for filtered rewards
  List<Map<String, dynamic>> affordableRewards = [];
  bool isLoadingRewards = true;

  @override
  void initState() {
    super.initState();
    fetchUserData(); 
    _petsFuture = _fetchPets();
    _fetchAffordableRewards(); // NEW: Fetch rewards
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // =============================
  // 3. FETCH DATA
  // =============================
  
  Future<void> fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            userName = "Guest";
            userProvince = "-";
          });
        }
        return;
      }

      final profileResponse = await Supabase.instance.client
          .from('owner_profile') 
          .select()
          .eq('user_id', user.id)
          .maybeSingle(); 

      final pointsResponse = await Supabase.instance.client
          .from('user_points')
          .select('total_points')
          .eq('user_id', user.id)
          .maybeSingle();

      if (mounted) {
        setState(() {
          if (profileResponse != null) {
            userName = profileResponse['display_name'] ?? profileResponse['full_name'] ?? "User"; 
            userProvince = profileResponse['province'] ?? "Belum ada lokasi"; 
            userAvatar = profileResponse['avatar_url'];
          } else {
            userName = user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? "User";
          }
          
          if (pointsResponse != null) {
            userPoints = pointsResponse['total_points'] ?? 0;
          }
        });
        
        // Reload rewards after points updated
        _fetchAffordableRewards();
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      if (mounted) {
        setState(() {
          userName = "User";
        });
      }
    }
  }

  // NEW: Fetch rewards that user can afford
  Future<void> _fetchAffordableRewards() async {
    try {
      setState(() => isLoadingRewards = true);
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        _loadFallbackRewards();
        return;
      }
      
      // Get user's total points
      final pointsResult = await Supabase.instance.client.rpc(
        'get_user_total_points',
        params: {'p_user_id': user.id},
      );
      
      final totalPoints = pointsResult as int? ?? 0;
      
      // Get all rewards from 'food' category
      final rewardsResult = await Supabase.instance.client.rpc(
        'get_rewards',
        params: {
          'p_category': 'food',
          'p_search_query': null,
        },
      );
      
      if (mounted) {
        setState(() {
          userPoints = totalPoints;
          
          if (rewardsResult is List && rewardsResult.isNotEmpty) {
            // Filter rewards that user can afford
            affordableRewards = List<Map<String, dynamic>>.from(rewardsResult)
                .where((reward) => (reward['points_required'] as int? ?? 0) <= totalPoints)
                .take(3) // Take only first 3
                .toList();
          } else {
            _loadFallbackRewards();
          }
          
          isLoadingRewards = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching affordable rewards: $e");
      _loadFallbackRewards();
    }
  }
  
  void _loadFallbackRewards() {
    final allRewards = [
      {'id': '23f65437-7a02-4323-8de0-b4d03e395757', 'name': 'Pasir Kucing', 'category': 'food', 'icon_path': 'assets/images/pasir.png', 'points_required': 1000},
      {'id': '347daa29-7905-4c63-875b-790f3b1e3101', 'name': 'Tempat Tidur', 'category': 'food', 'icon_path': 'assets/images/bed.png', 'points_required': 1300},
      {'id': '592089ac-362a-4687-b35a-d4a099012f61', 'name': 'Nutrisi Kucing', 'category': 'food', 'icon_path': 'assets/images/nutrisi.png', 'points_required': 1400},
      {'id': '459aede5-4a2f-49e7-bb6b-54c37d0ba474', 'name': 'Kandang', 'category': 'food', 'icon_path': 'assets/images/kandang.png', 'points_required': 2100},
      {'id': '1fe82384-8ee9-4297-bbff-1fdbf729b072', 'name': 'Rumah Kucing', 'category': 'food', 'icon_path': 'assets/images/rumah.png', 'points_required': 15000},
    ];
    
    setState(() {
      affordableRewards = allRewards
          .where((r) => (r['points_required'] as int? ?? 0) <= userPoints)
          .take(3)
          .toList();
      isLoadingRewards = false;
    });
  }

  Future<List<Pet>> _fetchPets() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return [];

      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('pets')
          .select()
          .eq('owner_id', user.id); 
      
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
                          Text(
                            "Halo, $userName!", 
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xff202020)
                            )
                          ),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.location_on_outlined, size: 15, color: Color(0xff828282)), 
                            const SizedBox(width: 4), 
                            Text(userProvince, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xff828282)))
                          ]),
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

              // --- VIRTUAL PET TITLE (Updated with Navigation) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to VpmHomeScreen (Main Virtual Pet Wellbeing Page)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VpmHomeScreen()),
                    );
                  },
                  child: Container(
                    color: Colors.transparent, // Ensures hit test works on full area
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Virtual Pet Wellbeings", 
                              textAlign: TextAlign.start,
                              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            // Arrow Icon
                            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                          ],
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
              ),

              const SizedBox(height: 16),

              // --- PET CONTENT ---
              FutureBuilder<List<Pet>>(
                future: _petsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator(color: Colors.orange)),
                    );
                  }
                  
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildEmptyPetState(context),
                    );
                  }

                  final pets = snapshot.data!;
                  return Column(
                    children: [
                      SizedBox(
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
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildMedicalRecordBanner(context), 
                      ),                
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // --- REWARDS SECTION (UPDATED WITH FILTERED DATA) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // REWARD HEADER -> Directs to RewardsPage
                    GestureDetector(
                      onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (_) => const RewardsPage()),
                         );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Rewards Point", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("Tukar poin dengan reward yang kamu mau!", style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // REWARD LIST -> Now shows filtered rewards
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

  Widget _buildEmptyPetState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
            child: const Icon(Icons.pets, size: 48, color: Colors.orange),
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada hewan peliharaan",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tambahkan hewan kesayanganmu untuk mulai memantau kesehatannya!",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPetScreen()),
              );
              if (result == true) {
                setState(() {
                  _petsFuture = _fetchPets();
                });
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              "Tambahkan Peliharaan",
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9F1C),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
            BoxShadow(
              color: const Color(0xFFFF9F1C).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
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

  // UPDATED: Now uses dynamic filtered data from Supabase
  Widget _buildRewardsList() {
    if (isLoadingRewards) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    if (affordableRewards.isEmpty) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Kumpulkan lebih banyak poin untuk membuka rewards! 🎁',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 160, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: affordableRewards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
           final item = affordableRewards[index];
           final imageUrl = item['icon_path'] ?? '';
           final rewardName = item['name'] ?? 'Reward';
           final pointsRequired = item['points_required']?.toString() ?? '0';
           final rewardId = item['id']?.toString() ?? 'unknown';
           
           return GestureDetector(
             onTap: () {
               // Direct to RewardConfirmationPage with real data
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => RewardConfirmationPage(
                     rewardId: rewardId,
                     rewardName: rewardName,
                     rewardPoints: '$pointsRequired points',
                     imageUrl: imageUrl,
                   )
                 ),
               );
             },
             child: Container(
               width: 120,
               padding: const EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(16),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.08), 
                     blurRadius: 10, 
                     offset: const Offset(0, 4)
                   )
                 ]
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Expanded(
                     child: imageUrl.isNotEmpty
                         ? (imageUrl.startsWith('http')
                             ? Image.network(
                                 imageUrl,
                                 fit: BoxFit.contain,
                                 errorBuilder: (c, e, s) => const Icon(Icons.card_giftcard, size: 40, color: Colors.orange),
                               )
                             : Image.asset(
                                 imageUrl,
                                 fit: BoxFit.contain,
                                 errorBuilder: (c, e, s) => const Icon(Icons.card_giftcard, size: 40, color: Colors.orange),
                               ))
                         : const Icon(Icons.card_giftcard, size: 40, color: Colors.orange),
                   ),
                   const SizedBox(height: 8),
                   Text(
                     rewardName, 
                     style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14), 
                     textAlign: TextAlign.center,
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                   const SizedBox(height: 4),
                   Text(
                     "$pointsRequired pts", 
                     style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w600)
                   ),
                 ],
               ),
             ),
           );
        },
      ),
    );
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