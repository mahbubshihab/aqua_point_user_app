import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final String id;
  final String name;
  final String industry;
  final String logoUrl;
  final DateTime? createdAt;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.industry,
    required this.logoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, industry, logoUrl, createdAt];
}
