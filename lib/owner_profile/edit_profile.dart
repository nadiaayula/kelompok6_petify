import 'package:flutter/material.dart';

void main() {
  runApp(const EditProfileApp());
}

class EditProfileApp extends StatelessWidget {
  const EditProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  Widget formField(String placeholder, {Widget? prefix, Widget? suffix}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          if (prefix != null) prefix,
          if (prefix != null) const SizedBox(width: 14),
          Expanded(
            child: Text(
              placeholder,
              style: const TextStyle(
                color: Color(0xFFBEBEBE),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
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
            children: [
              const SizedBox(height: 20),

              // BACK BUTTON + TITLE
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
                          size: 20, color: Colors.black45),
                      onPressed: () {},
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Edit Profil",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 50),
                ],
              ),

              const SizedBox(height: 28),

              // PROFILE PHOTO
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "🤵🏻‍♂️",
                        style: TextStyle(fontSize: 70),
                      ),
                    ),
                  ),

                  // EDIT PHOTO BUTTON
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 40),

              // FORM FIELDS
              formField("Nama lengkap"),
              const SizedBox(height: 16),

              formField(
                "Jenis Kelamin",
                suffix: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.black26),
              ),
              const SizedBox(height: 16),

              formField("Tanggal lahir"),
              const SizedBox(height: 16),

              // PHONE NUMBER WITH FLAG
              formField(
                "Nomor telepon",
                prefix: Container(
                  height: 18,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                suffix: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: Colors.black26),
              ),
              const SizedBox(height: 16),

              formField(
                "E-mail",
                suffix: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              formField("Alamat rumah"),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: formField("Provinsi")),
                  const SizedBox(width: 16),
                  Expanded(child: formField("Kode pos")),
                ],
              ),

              const SizedBox(height: 40),

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
