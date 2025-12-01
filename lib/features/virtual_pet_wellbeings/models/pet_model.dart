class Pet {
  final String id;
  final String name;
  final String type;
  final String age;
  final String weight;
  final String gender;
  final String breed;
  final String imageUrl;

  const Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    required this.gender,
    required this.breed,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'weight': weight,
      'gender': gender,
      'breed': breed,
      'imageUrl': imageUrl,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      age: map['age'],
      weight: map['weight'],
      gender: map['gender'],
      breed: map['breed'],
      imageUrl: map['imageUrl'],
    );
  }
}