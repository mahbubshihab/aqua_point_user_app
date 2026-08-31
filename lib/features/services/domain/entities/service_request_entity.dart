import 'package:equatable/equatable.dart';

class ServiceRequestEntity extends Equatable {
  final String id;
  final String address;
  final String date;
  final String timeSlot;
  final String description;
  final String status;
  final String? technician;
  final String? technicianPhone;

  const ServiceRequestEntity({
    required this.id,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.description,
    required this.status,
    this.technician,
    this.technicianPhone,
  });

  ServiceRequestEntity copyWith({
    String? id,
    String? address,
    String? date,
    String? timeSlot,
    String? description,
    String? status,
    String? technician,
    String? technicianPhone,
  }) {
    return ServiceRequestEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      description: description ?? this.description,
      status: status ?? this.status,
      technician: technician ?? this.technician,
      technicianPhone: technicianPhone ?? this.technicianPhone,
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
        technician,
        technicianPhone,
      ];
}

