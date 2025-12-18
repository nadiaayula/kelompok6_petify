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
  String userCode = "";
  int userPoints = 0;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final supabase = Supabase.instance.client;
final user = supabase.auth.currentUser;

if (user == null) return;

// OWNER PROFILE
final profileResponse = await supabase
    .from('owner_profile')
    .select('display_name, avatar_url, province')
    .eq('user_id', user.id)
    .maybeSingle();

// USER POINTS (kolom: total_point)
final pointsResponse = await supabase
    .from('user_points')
    .select('total_points')
    .eq('user_id', user.id)
    .maybeSingle();

if (!mounted) return;

setState(() {
  // PROFILE
  if (profileResponse != null) {
    displayName = profileResponse['display_name'] ?? "User";
    province = profileResponse['province'] ?? "Belum ada lokasi";
    avatarUrl = profileResponse['avatar_url'];
  } else {
    displayName = "User";
    province = "Belum ada lokasi";
  }

  // KODE USER → 5 karakter awal UUID
  userCode = user.id.substring(0, 5);

  // POINTS
  userPoints = pointsResponse?['total_points'] ?? 0;
});

  }

    /* ================= HAPUS AKUN ================= */

  Future<void> _confirmDeleteAccount() async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFFF3EDF7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kamu akan logout akun, yakin?',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteAccount();
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

  Future<void> _deleteAccount() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // hapus data profile
      await Supabase.instance.client
          .from('owner_profile')
          .delete()
          .eq('user_id', user.id);

      // hapus akun auth
      await Supabase.instance.client.auth.signOut();

      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus akun')),
      );
    }
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
            userCode: userCode,
            userPoints: userPoints,
          ),


          const SizedBox(height: 24),

          _Section(title: 'Umum'),
          _Tile(
            icon: Icons.language,
            title: 'Bahasa',
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                      canvasColor: Colors.white,
                    ),
                    child: const LanguageSheet(),
                  );
                },
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
          const SizedBox(height: 16),

          /* ===== MENU HAPUS AKUN ===== */
          _Section(title: 'Akun'),
          _Tile(
            icon: Icons.delete_outline,
            title: 'Hapus Akun',
            onTap: _confirmDeleteAccount,
          ),
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
          Positioned(
            left: 16,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
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
  final String userCode;
  final int userPoints;

  const _ProfileCard({
    required this.avatarUrl,
    required this.name,
    required this.province,
    required this.userCode,
    required this.userPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        avatarUrl != null && avatarUrl!.isNotEmpty
                            ? NetworkImage(avatarUrl!)
                            : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, size: 36, color: Colors.grey)
                        : null,
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
                            userCode.trim().isEmpty
                                ? "Loading points..."
                                : "#$userCode · $userPoints points",
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
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
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
                  const Icon(Icons.location_on_outlined,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(province,
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ],
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
              title: Text(l['name']!,
                  style: const TextStyle(color: Colors.black)),
              trailing: selected == l['code']
                  ? const Icon(Icons.check, color: Colors.black)
                  : null,
              onTap: () {
                setState(() => selected = l['code']!);
                Navigator.pop(context);
              },
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
