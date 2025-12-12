class User {
  final String userId;
  final String displayName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? gender;
  final DateTime? birthDate;
  final String? address;
  final String? province;
  final String? postalCode;

  User({
    required this.userId,
    required this.displayName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.gender,
    this.birthDate,
    this.address,
    this.province,
    this.postalCode,
  });

  // Convert to Map for Supabase (owner_profile table)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'display_name': displayName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'gender': gender,
      'birth_date': birthDate?.toIso8601String(),
      'address': address,
      'province': province,
      'postal_code': postalCode,
    };
  }

  // Create User from Supabase data
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'] ?? '',
      displayName: map['display_name'] ?? '',
      phone: map['phone'],
      avatarUrl: map['avatar_url'],
      gender: map['gender'],
      birthDate: map['birth_date'] != null 
          ? DateTime.parse(map['birth_date'])
          : null,
      address: map['address'],
      province: map['province'],
      postalCode: map['postal_code'],
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() => toMap();

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);

  // Copy with method (untuk update data)
  User copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? gender,
    DateTime? birthDate,
    String? address,
    String? province,
    String? postalCode,
  }) {
    return User(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      address: address ?? this.address,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
