import 'package:equatable/equatable.dart';

class WaterServiceEntity extends Equatable {
  final String id;
  final String address;
  final String date;
  final String timeSlot;
  final String description;
  final String status;
  final String? createdAt;
  final String? userId;
  final String? serviceType;
  final String? technicianId;
  final double? amount;

  const WaterServiceEntity({
    required this.id,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.description,
    required this.status,
    this.createdAt,
    this.userId,
    this.serviceType,
    this.technicianId,
    this.amount,
  });

  WaterServiceEntity copyWith({
    String? id,
    String? address,
    String? date,
    String? timeSlot,
    String? description,
    String? status,
    String? createdAt,
    String? userId,
    String? serviceType,
    String? technicianId,
    double? amount,
  }) {
    return WaterServiceEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      serviceType: serviceType ?? this.serviceType,
      technicianId: technicianId ?? this.technicianId,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        address,
        date,
        timeSlot,
        description,
        status,
        createdAt,
        userId,
        serviceType,
        technicianId,
        amount,
      ];
}
