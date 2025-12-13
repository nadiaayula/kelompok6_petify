import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_profile.dart';
import 'package:kelompok6_adoptify/features/rewards/screens/rewards_page.dart';
import 'package:kelompok6_adoptify/features/history/history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName = "Loading...";
  String province = "Loading...";
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await Supabase.instance.client
        .from("owner_profile")
        .select()
        .eq("user_id", user.id)
        .single();

    setState(() {
      displayName = data['display_name'] ?? "User";
      province = data['province'] ?? "-";
      avatarUrl = data['avatar_url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Header(),
          const SizedBox(height: 16),

          _ProfileCard(
            avatarUrl: avatarUrl,
            name: displayName,
            province: province,
          ),

          const SizedBox(height: 24),

          _Section(title: 'Umum'),
          _Tile(
            icon: Icons.language,
            title: 'Bahasa',
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const LanguageSheet(),
              );
            },
          ),
          const _Tile(icon: Icons.notifications_none, title: 'Notifikasi'),
          const _Tile(icon: Icons.star_border, title: 'Rating aplikasi'),

          const SizedBox(height: 16),

          _Section(title: 'Bantuan'),
          const _Tile(icon: Icons.support_agent, title: 'Pusat bantuan'),
          const _Tile(icon: Icons.report_outlined, title: 'Laporan'),

          const SizedBox(height: 16),

          _Section(title: 'Tentang'),
          const _Tile(icon: Icons.info_outline, title: 'Tentang kami'),
          const _Tile(icon: Icons.privacy_tip_outlined, title: 'Kebijakan aplikasi'),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/* ================= HEADER ================= */

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: 56),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          // BACK BUTTON ←
          Positioned(
            left: 16,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context); // balik ke dashboard
              },
            ),
          ),

          // TITLE
          const Center(
            child: Text(
              'Profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= PROFILE CARD ================= */

class _ProfileCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String province;

  const _ProfileCard({
    required this.avatarUrl,
    required this.name,
    required this.province,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                        ? NetworkImage(avatarUrl!)
                        : const NetworkImage("https://placehold.co/200/png?text=A"),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "#56790 · 1.500 points",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.edit, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    province,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      text: 'Rewards',
                      backgroundColor: const Color(0xFFE6E1FF),
                      textColor: const Color(0xFF6A5AE0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RewardsPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      text: 'History',
                      backgroundColor: const Color(0xFFFFF1D6),
                      textColor: const Color(0xFFFF9800),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HistoryPage(filter: HistoryFilter.all),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= ACTION BUTTON ================= */

class _ActionButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= LANGUAGE SHEET ================= */

class LanguageSheet extends StatefulWidget {
  const LanguageSheet({super.key});

  @override
  State<LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<LanguageSheet> {
  String selected = 'id';

  final langs = const [
    {'code': 'id', 'name': 'Bahasa Indonesia'},
    {'code': 'en', 'name': 'English'},
    {'code': 'jp', 'name': '日本語'},
    {'code': 'kr', 'name': '한국어'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih Bahasa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...langs.map(
            (l) => ListTile(
              title: Text(l['name']!),
              trailing: selected == l['code']
                  ? const Icon(Icons.check, color: Colors.orange)
                  : null,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= COMMON ================= */

class _Section extends StatelessWidget {
  final String title;
  const _Section({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const _Tile({
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
