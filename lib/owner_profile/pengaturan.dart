import 'package:flutter/material.dart';

void main() {
  runApp(const BahasaApp());
}

class BahasaApp extends StatelessWidget {
  const BahasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BahasaPage(),
    );
  }
}

class BahasaPage extends StatefulWidget {
  const BahasaPage({super.key});

  @override
  State<BahasaPage> createState() => _BahasaPageState();
}

class _BahasaPageState extends State<BahasaPage> {
  String selected = "Indonesia";

  final List<Map<String, dynamic>> languages = [
    {"name": "Australia", "flag": "🇦🇺"},
    {"name": "Austria", "flag": "🇦🇹"},
    {"name": "Brazil", "flag": "🇧🇷"},
    {"name": "Finlandia", "flag": "🇫🇮"},
    {"name": "Indonesia", "flag": "🇮🇩"},
    {"name": "Jerman", "flag": "🇩🇪"},
    {"name": "Korea Selatan", "flag": "🇰🇷"},
    {"name": "Kroasia", "flag": "🇭🇷"},
    {"name": "Mesir", "flag": "🇪🇬"},
  ];

  Widget languageItem(String name, String flag) {
    final bool isSelected = selected == name;

    return GestureDetector(
      onTap: () {
        setState(() => selected = name);
      },
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9800) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFFE5E5E5),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            Text(flag, style: const TextStyle(fontSize: 26)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // HEADER
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black54, size: 20),
                      onPressed: () {},
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Bahasa",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 50),
                ],
              ),

              const SizedBox(height: 30),

              // LIST BAHASA
              ...languages.map((e) => languageItem(e["name"], e["flag"])),

              const SizedBox(height: 20),

              // SAVE BUTTON
              Container(
                height: 64,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
