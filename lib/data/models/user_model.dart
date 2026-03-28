class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime joinedDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.joinedDate,
  });

  factory UserModel.empty() => UserModel(
        id: '',
        name: 'Guest',
        email: '',
        joinedDate: DateTime.now(),
      );

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? joinedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'joinedDate': joinedDate.toIso8601String(),
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        photoUrl: map['photoUrl'],
        joinedDate: map['joinedDate'] != null
            ? DateTime.parse(map['joinedDate'])
            : DateTime.now(),
      );

  bool get isLoggedIn => id.isNotEmpty;

  String get initials {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
