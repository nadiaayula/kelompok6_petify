import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'reward_confirmation_page.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();
  
  String selectedCategory = 'health';
  int totalPoints = 0;
  List<Map<String, dynamic>> allRewards = [];
  List<Map<String, dynamic>> kebutuhanUtamaRewards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        // Fallback ke dummy data kalau belum login
        _loadFallbackData();
        return;
      }
      
      // Load total points
      final pointsResult = await supabase.rpc('get_user_total_points', params: {
        'p_user_id': userId,
      });
      
      // Load all rewards
      final rewardsResult = await supabase.rpc('get_rewards', params: {
        'p_category': null,
        'p_search_query': null,
      });
      
      // Load kebutuhan utama rewards
      final utamaResult = await supabase.rpc('get_rewards', params: {
        'p_category': 'food',
        'p_search_query': null,
      });
      
      setState(() {
        totalPoints = pointsResult as int? ?? 0;
        if (rewardsResult is List && rewardsResult.isNotEmpty) {
          allRewards = List<Map<String, dynamic>>.from(rewardsResult);
        } else {
          // Fallback kalau database kosong
          _loadFallbackData();
          return;
        }
        if (utamaResult is List) {
          kebutuhanUtamaRewards = List<Map<String, dynamic>>.from(utamaResult);
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading rewards: $e');
      // Fallback kalau ada error
      _loadFallbackData();
    }
  }
  
  void _loadFallbackData() {
    // Dummy data kalau database kosong atau error
    setState(() {
      allRewards = [
        {'id': 'dummy-1', 'name': 'Pet Kit', 'category': 'utama', 'icon_path': 'assets/images/medical_kit.png', 'points_required': 500, 'stock': 50, 'is_active': true},
        {'id': 'dummy-2', 'name': 'Makanan', 'category': 'utama', 'icon_path': 'assets/images/makanan.png', 'points_required': 250, 'stock': 100, 'is_active': true},
        {'id': 'dummy-3', 'name': 'Sisir Bulu', 'category': 'utama', 'icon_path': 'assets/images/sisir.png', 'points_required': 150, 'stock': 75, 'is_active': true},
        {'id': 'dummy-4', 'name': 'Paket Medis', 'category': 'kesehatan', 'icon_path': 'assets/images/medical_kit.png', 'points_required': 1310, 'stock': 30, 'is_active': true},
        {'id': 'dummy-5', 'name': 'Nutrisi Kucing', 'category': 'kesehatan', 'icon_path': 'assets/images/makanan.png', 'points_required': 1400, 'stock': 40, 'is_active': true},
        {'id': 'dummy-6', 'name': 'Sabun Mandi Kucing', 'category': 'kesehatan', 'icon_path': 'assets/images/mandi.png', 'points_required': 430, 'stock': 60, 'is_active': true},
        {'id': 'dummy-7', 'name': 'Rumah Kucing', 'category': 'tambahan', 'icon_path': 'assets/images/rumah.png', 'points_required': 15000, 'stock': 10, 'is_active': true},
        {'id': 'dummy-8', 'name': 'Bola Mainan', 'category': 'mainan', 'icon_path': 'assets/images/bola.png', 'points_required': 200, 'stock': 80, 'is_active': true},
      ];
      
      kebutuhanUtamaRewards = allRewards.where((r) => r['category'] == 'food').toList();
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> getFilteredRewards() {
    var filtered = allRewards.where((r) => r['category'] == selectedCategory).toList();
    
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((r) {
        final name = (r['name'] ?? '').toString().toLowerCase();
        return name.contains(query);
      }).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                // Header with points
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Icon(Icons.diamond, color: Colors.blue, size: 28),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$totalPoints points',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Tukar poinmu dengan rewards menarik',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.amber,
                        child: Text('👨', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                  ),
                ),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Penelusuran',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.orange),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple[100]!,
                                    Colors.blue[50]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rewards paling\nbanyak dipilih nih!',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Minimal 250 points',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/makanan.png',
                                    width: 100,
                                    height: 80,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.orange[100],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.card_giftcard, size: 40),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Kebutuhan Utama section
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kebutuhan Utama',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tukar poinmu dengan rewards dari Adoptify',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Horizontal scroll items
                          SizedBox(
                            height: 220,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                _buildRewardCard(
                                  'Reward yang\nSesuai\nUntukmu!',
                                  '',
                                  Colors.green[100]!,
                                  isSpecial: true,
                                ),
                                ...kebutuhanUtamaRewards.map((reward) {
                                  return _buildRewardCard(
                                    reward['name'] ?? '',
                                    '${reward['points_required']} points',
                                    Colors.white,
                                    imageUrl: reward['icon_path'],
                                    rewardId: reward['id'],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Rewards section with tabs
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rewards',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Tukar poinmu dengan reward dari Adoptify',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.tune),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Category tabs
                          SizedBox(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                _buildCategoryTab('Kebutuhan Utama', 'food'),
                                _buildCategoryTab('Tambahan', 'accessories'),
                                _buildCategoryTab('Kesehatan', 'health'),
                                _buildCategoryTab('Mainan', 'toys'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Reward items list
                          ...getFilteredRewards().map((reward) {
                            return _buildRewardItem(
                              reward['name'] ?? '',
                              'Dibutuhkan minimal perolehan',
                              '${reward['points_required']} points',
                              Icons.card_giftcard,
                              Colors.orange[100]!,
                              rewardId: reward['id'],
                              imageUrl: reward['icon_path'],
                            );
                          }).toList(),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildRewardCard(String title, String points, Color color, {bool isSpecial = false, String? imageUrl, String? rewardId}) {
    return GestureDetector(
      onTap: isSpecial ? null : () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RewardConfirmationPage(
              rewardId: rewardId ?? '',
              rewardName: title,
              rewardPoints: points,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isSpecial) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: imageUrl == null ? Colors.grey[200] : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: imageUrl.startsWith('http')
                            ? Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 40))
                            : Image.asset(imageUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 40)),
                        ),
                      )
                    : const Icon(Icons.pets, size: 40),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: isSpecial ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: isSpecial ? TextAlign.left : TextAlign.center,
            ),
            if (!isSpecial && points.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                points,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, String category) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem(String title, String subtitle, String points, IconData icon, Color iconBg, {String? rewardId, String? imageUrl}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RewardConfirmationPage(
              rewardId: rewardId ?? '',
              rewardName: title,
              rewardPoints: points,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    points,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}