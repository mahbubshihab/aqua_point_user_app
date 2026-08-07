import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String avatarUrl;
  final int totalPoints;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.avatarUrl,
    required this.totalPoints,
  });

  UserProfileEntity copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? avatarUrl,
    int? totalPoints,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        address,
        avatarUrl,
        totalPoints,
      ];
}
