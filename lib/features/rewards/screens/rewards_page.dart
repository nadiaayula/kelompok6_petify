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
  
  String selectedCategory = 'food';
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
        _loadFallbackData();
        return;
      }
      
      final pointsResult = await supabase.rpc('get_user_total_points', params: {
        'p_user_id': userId,
      });
      
      final rewardsResult = await supabase.rpc('get_rewards', params: {
        'p_category': null,
        'p_search_query': null,
      });
      
      final utamaResult = await supabase.rpc('get_rewards', params: {
        'p_category': 'food',
        'p_search_query': null,
      });
      
      setState(() {
        totalPoints = pointsResult as int? ?? 0;
        if (rewardsResult is List && rewardsResult.isNotEmpty) {
          allRewards = List<Map<String, dynamic>>.from(rewardsResult);
        } else {
          _loadFallbackData();
          return;
        }
        if (utamaResult is List) {
          // Filter rewards yang poinnya <= total points user
          kebutuhanUtamaRewards = List<Map<String, dynamic>>.from(utamaResult)
              .where((reward) => (reward['points_required'] as int? ?? 0) <= totalPoints)
              .toList();
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error loading rewards: $e');
      _loadFallbackData();
    }
  }
  
  void _loadFallbackData() {
    setState(() {
      allRewards = [
        // Kategori Food (Utama)
        {'id': '1fe82384-8ee9-4297-bbff-1fdbf729b072', 'name': 'Rumah Kucing', 'category': 'food', 'icon_path': 'assets/images/rumah.png', 'points_required': 15000, 'stock': 10, 'is_active': true},
        {'id': '23f65437-7a02-4323-8de0-b4d03e395757', 'name': 'Pasir Kucing', 'category': 'food', 'icon_path': 'assets/images/pasir.png', 'points_required': 1000, 'stock': 65, 'is_active': true},
        {'id': '347daa29-7905-4c63-875b-790f3b1e3101', 'name': 'Tempat Tidur', 'category': 'food', 'icon_path': 'assets/images/bed.png', 'points_required': 1300, 'stock': 45, 'is_active': true},
        {'id': '459aede5-4a2f-49e7-bb6b-54c37d0ba474', 'name': 'Kandang', 'category': 'food', 'icon_path': 'assets/images/kandang.png', 'points_required': 2100, 'stock': 20, 'is_active': true},
        {'id': '592089ac-362a-4687-b35a-d4a099012f61', 'name': 'Nutrisi Kucing', 'category': 'food', 'icon_path': 'assets/images/nutrisi.png', 'points_required': 1400, 'stock': 99, 'is_active': true},
        
        // Kategori Accessories (Tambahan)
        {'id': '647daa29-7905-4c63-875b-790f3b1e3102', 'name': 'Sabun Mandi Kucing', 'category': 'accessories', 'icon_path': 'assets/images/sabun.png', 'points_required': 430, 'stock': 60, 'is_active': true},
        {'id': '76c4f279-4ae3-4f38-b649-663dbe0403d1', 'name': 'Kalung', 'category': 'accessories', 'icon_path': 'assets/images/kalung.png', 'points_required': 870, 'stock': 50, 'is_active': true},
        {'id': '88e2bf31-8514-4137-a188-0ba60529fc74', 'name': 'Tempat Makan', 'category': 'accessories', 'icon_path': 'assets/images/tempat_makan.png', 'points_required': 700, 'stock': 75, 'is_active': true},
        {'id': '9cb1b6ab-5820-4ac5-97fa-ec263fd3d45c', 'name': 'Boneka Tikus', 'category': 'accessories', 'icon_path': 'assets/images/tikus.png', 'points_required': 300, 'stock': 70, 'is_active': true},
        {'id': '10a11c50-2a92-4cad-955e-c6ef341fee51', 'name': 'Sekop Pasir', 'category': 'accessories', 'icon_path': 'assets/images/sekop.png', 'points_required': 200, 'stock': 80, 'is_active': true},
        
        // Kategori Health (Kesehatan)
        {'id': '1159aede-4a2f-49e7-bb6b-54c37d0ba475', 'name': 'Paket Medis', 'category': 'health', 'icon_path': 'assets/images/paket_medis.png', 'points_required': 1310, 'stock': 30, 'is_active': true},
        {'id': '1292089a-362a-4687-b35a-d4a099012f62', 'name': 'Nutrisi Kucing', 'category': 'health', 'icon_path': 'assets/images/nutrisi.png', 'points_required': 1400, 'stock': 99, 'is_active': true},
        {'id': '1347daa2-7905-4c63-875b-790f3b1e3103', 'name': 'Sabun Mandi Kucing', 'category': 'health', 'icon_path': 'assets/images/sabun.png', 'points_required': 430, 'stock': 60, 'is_active': true},
        
        // Kategori Toys (Mainan)
        {'id': '145d8606-63e4-4697-97b5-3472dbb402c1', 'name': 'Boneka Tulang', 'category': 'toys', 'icon_path': 'assets/images/boneka_tulang.png', 'points_required': 430, 'stock': 55, 'is_active': true},
        {'id': '155d8606-63e4-4697-97b5-3472dbb402c2', 'name': 'Bola', 'category': 'toys', 'icon_path': 'assets/images/bola.png', 'points_required': 230, 'stock': 80, 'is_active': true},
        {'id': '16cb1b6a-5820-4ac5-97fa-ec263fd3d45d', 'name': 'Boneka Tikus', 'category': 'toys', 'icon_path': 'assets/images/tikus.png', 'points_required': 300, 'stock': 70, 'is_active': true},
      ];
      
      // Filter rewards yang poinnya <= total points user
      kebutuhanUtamaRewards = allRewards
          .where((r) => r['category'] == 'food' && (r['points_required'] as int? ?? 0) <= totalPoints)
          .toList();
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

                          // Horizontal scroll items - FILTERED by user points
                          SizedBox(
                            height: 220,
                            child: kebutuhanUtamaRewards.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Kumpulkan lebih banyak poin untuk membuka rewards! 🎁',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : ListView(
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
                                _buildCategoryTab('Utama', 'food'),
                                _buildCategoryTab('Tambahan', 'accessories'),
                                _buildCategoryTab('Kesehatan', 'health'),
                                _buildCategoryTab('Mainan', 'toys'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Reward items list
                          ...getFilteredRewards().map((reward) {
                            return _buildRewardItemNew(
                              reward['name'] ?? '',
                              'Dibutuhkan minimal perolehan',
                              '${reward['points_required']} points',
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

  Widget _buildRewardItemNew(String title, String subtitle, String points, {String? rewardId, String? imageUrl}) {
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
            // Gambar produk
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageUrl != null
                  ? (imageUrl.startsWith('http')
                      ? Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.card_giftcard, size: 32))
                      : Image.asset(imageUrl, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.card_giftcard, size: 32)))
                  : const Icon(Icons.card_giftcard, size: 32, color: Colors.orange),
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