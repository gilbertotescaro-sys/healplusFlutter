
class UserProfile {
  final int? id;
  final String name;
  final String email;
  final String? specialty;
  final String? crmCoren;
  final String? profileImagePath;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    this.id,
    required this.name,
    required this.email,
    this.specialty,
    this.crmCoren,
    this.profileImagePath,
    String? createdAt,
    String? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialty': specialty,
      'crm_coren': crmCoren,
      'profile_image_path': profileImagePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      specialty: map['specialty'],
      crmCoren: map['crm_coren'],
      profileImagePath: map['profile_image_path'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? specialty,
    String? crmCoren,
    String? profileImagePath,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      specialty: specialty ?? this.specialty,
      crmCoren: crmCoren ?? this.crmCoren,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

