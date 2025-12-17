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

  // Mapper dari JSON Supabase ke Object Flutter
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      gender: json['gender'],
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : null,
      weightKg: (json['weight_kg'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}