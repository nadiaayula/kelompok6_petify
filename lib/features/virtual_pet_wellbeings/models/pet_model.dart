class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String species; 
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


  String get age {
    if (birthDate == null) return "Unknown";
    final now = DateTime.now();
    final difference = now.difference(birthDate!);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    
    if (years > 0) return "$years Thn $months Bln";
    return "$months Bulan";
  }

  
  factory Pet.fromJson(Map<String, dynamic> json) {
    String rawGender = (json['gender'] ?? '').toString().toLowerCase().trim();
    String rawSpecies = (json['species'] ?? '').toString().toLowerCase().trim();

    String displayGender;
    if (rawGender == 'male') {
      displayGender = 'Jantan';
    } else if (rawGender == 'female') {
      displayGender = 'Betina';
    } else {
      displayGender = json['gender'] ?? 'Unknown'; 
    }
    
    
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
      species: displaySpecies, 
      breed: json['breed'],
      gender: displayGender,   
      birthDate: json['birth_date'] != null 
          ? DateTime.parse(json['birth_date']) 
          : null,
      weightKg: (json['weight_kg'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}