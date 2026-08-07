import 'package:equatable/equatable.dart';

class ServiceRequestEntity extends Equatable {
  final String id;
  final String machineName;
  final String address;
  final String date;
  final String timeSlot;
  final String description;
  final String status;

  const ServiceRequestEntity({
    required this.id,
    required this.machineName,
    required this.address,
    required this.date,
    required this.timeSlot,
    required this.description,
    required this.status,
  });

  ServiceRequestEntity copyWith({
    String? id,
    String? machineName,
    String? address,
    String? date,
    String? timeSlot,
    String? description,
    String? status,
  }) {
    return ServiceRequestEntity(
      id: id ?? this.id,
      machineName: machineName ?? this.machineName,
      address: address ?? this.address,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        machineName,
        address,
        date,
        timeSlot,
        description,
        status,
      ];
}
