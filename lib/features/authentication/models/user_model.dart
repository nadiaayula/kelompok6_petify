class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create User from Map (from database/API)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() => toMap();

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);

  // Copy with method (untuk update data)
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
