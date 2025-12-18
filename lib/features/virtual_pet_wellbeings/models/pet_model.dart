class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String species; // Ini adalah 'type' di UI kamu (Kucing/Anjing)
  final String? breed;
  final String gender;
  final DateTime? birthDate;
  final double weightKg;
  final String? imageUrl;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    required this.gender,
    this.birthDate,
    required this.weightKg,
    this.imageUrl,
  });

  // Getter untuk menghitung umur secara otomatis dari birthDate
  String get age {
    if (birthDate == null) return "Unknown";
    final now = DateTime.now();
    final difference = now.difference(birthDate!);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    
    if (years > 0) return "$years Thn $months Bln";
    return "$months Bulan";
  }

  // Mapper dari JSON Supabase ke Object Flutter (Update di pet_model.dart)
  factory Pet.fromJson(Map<String, dynamic> json) {
    // 1. Ambil data mentah dari JSON dan bersihkan (kecilkan huruf & hapus spasi)
    String rawGender = (json['gender'] ?? '').toString().toLowerCase().trim();
    String rawSpecies = (json['species'] ?? '').toString().toLowerCase().trim();

    // 2. Mapping Gender: DB ('male'/'female') -> UI ('Jantan'/'Betina')
    String displayGender;
    if (rawGender == 'male') {
      displayGender = 'Jantan';
    } else if (rawGender == 'female') {
      displayGender = 'Betina';
    } else {
      displayGender = json['gender'] ?? 'Unknown'; // Fallback kalau datanya aneh
    }
    
    // 3. Mapping Species: DB ('cat'/'dog') -> UI ('Kucing'/'Anjing')
    // Ini KUNCI supaya gambar Kucing muncul beneran (tidak jadi Anjing terus)
    String displaySpecies;
    if (rawSpecies == 'cat' || rawSpecies == 'kucing') {
      displaySpecies = 'Kucing';
    } else if (rawSpecies == 'dog' || rawSpecies == 'anjing') {
      displaySpecies = 'Anjing';
    } else {
      displaySpecies = json['species'] ?? 'Unknown';
    }

    return Pet(
      id: json['id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      name: json['name'] ?? 'Tanpa Nama',
      species: displaySpecies, // Hasil terjemahan tadi dipakai di sini
      breed: json['breed'],
      gender: displayGender,   // Hasil terjemahan tadi dipakai di sini
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : null,
      weightKg: (json['weight_kg'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}