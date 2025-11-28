import 'package:flutter/material.dart';

// to do; ganti semua icon jadi asset, ganti font yang dipake.

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // gunakan path persis file yang diupload
  final String headerImageUrl = 'file:///mnt/data/PROFILE PAGE - MAIN.png';

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 260;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          // CONTENT SCROLL
          Positioned.fill(
            top: headerHeight * 0.45,
            child: const _ContentList(),
          ),

          // ORANGE HEADER WITH BACKGROUND SHAPE
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFA726),
                  Color(0xFFFF9800),
                ],
                begin: Alignment(-0.9, -0.2),
                end: Alignment(0.9, 0.8),
              ),
              image: DecorationImage(
                image: NetworkImage(headerImageUrl),
                fit: BoxFit.cover,
                opacity: 0.06, // subtle decorative overlay dari file
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                )
              ],
            ),
          ),

          // HEADER TITLE + ICONS
          SafeArea(
            child: SizedBox(
              height: headerHeight,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  _CircleIconButton(icon: Icons.arrow_back),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  _CircleIconButton(icon: Icons.logout),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),

          // PROFILE CARD (floating)
          Positioned(
            left: 18,
            right: 18,
            top: headerHeight - 60,
            child: _ProfileCard(),
          ),

          // BOTTOM NAV
          const Align(
            alignment: Alignment.bottomCenter,
            child: _BottomNavBar(),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  const _CircleIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white),
        iconSize: 22,
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // avatar (memoji-like) - using emoji/text for quick match
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  '😀', // ganti jadi assert
                  style: TextStyle(fontSize: 34),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // name + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Rudi Tabuti',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '#56790 · 1.500 points',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // eye icon button
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAEAEA)),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye_outlined),
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentList extends StatelessWidget {
  const _ContentList();

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget tile(IconData icon, String title, {String? trailing}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey[600]),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8E8E8E),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailing,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
                  ],
                )
              : const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, color: Color(0xFFF0F0F0)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // grow enough for bottom nav spacing
    return ListView(
      padding: EdgeInsets.only(top: 120, bottom: 110),
      children: [
        sectionTitle('Umum'),
        tile(Icons.language, 'Bahasa', trailing: 'IND'),
        tile(Icons.notifications_none, 'Notifikasi'),
        tile(Icons.star_border, 'Rating aplikasi'),
        const SizedBox(height: 14),
        sectionTitle('Bantuan'),
        tile(Icons.support_agent, 'Pusat bantuan'),
        tile(Icons.report_gmailerrorred_outlined, 'Laporan'),
        const SizedBox(height: 14),
        sectionTitle('Tentang'),
        tile(Icons.info_outline, 'Tentang kami'),
        tile(Icons.privacy_tip_outlined, 'Kebijakan aplikasi'),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      // translucent top shadow
      decoration: const BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -3))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(icon: Icons.home_outlined, active: false),
              _NavIcon(icon: Icons.bookmark_border, active: false),
              _NavIcon(icon: Icons.pets_outlined, active: false),
              _NavIcon(icon: Icons.grid_view_outlined, active: false),
              _NavIcon(icon: Icons.person, active: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool active;
  const _NavIcon({required this.icon, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: active ? Colors.black : Colors.grey[300]),
        const SizedBox(height: 6),
        // small active indicator for the profile icon
        if (active)
          Container(
            height: 4,
            width: 18,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
          )
        else
          const SizedBox(height: 4),
      ],
    );
  }
}
