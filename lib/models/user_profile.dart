class UserProfile {
  final int? id;
  final String name;
  final String email;

  UserProfile._({
    this.id, 
    required this.name, 
    required this.email
    });

  factory UserProfile({
    int? id, 
    required String name, 
    required String email
    }) {
    if (name.trim().isEmpty) throw ArgumentError('User name cannot be empty.');
    if (email.trim().isEmpty) throw ArgumentError('User email cannot be empty.');
    return UserProfile._(
      id: id, 
      name: name, 
      email: email
    );
  }

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
    };
  }

  factory UserProfile.fromMap(Map<String, Object?> map) {
    return UserProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
