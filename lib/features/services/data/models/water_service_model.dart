import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/water_service_entity.dart';

class WaterServiceModel extends WaterServiceEntity {
  const WaterServiceModel({
    required super.id,
    required super.machineName,
    required super.address,
    required super.date,
    required super.timeSlot,
    required super.description,
    required super.status,
    super.customerName,
    super.phone,
  });

  factory WaterServiceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return WaterServiceModel(
      id: doc.id,
      machineName: data['machineModel'] ?? data['machineType'] ?? data['title'] ?? 'RO Water Purifier',
      address: data['address'] ?? 'N/A',
      date: data['appointmentDate'] ?? data['preferredDate'] ?? data['date'] ?? '',
      timeSlot: data['appointmentTime'] ?? data['preferredSlot'] ?? data['timeSlot'] ?? '',
      description: data['problemDetails'] ?? data['problemDescription'] ?? data['description'] ?? '',
      status: data['status'] ?? 'Pending',
      customerName: data['customerName'],
      phone: data['phone'],
    );
  }

  factory WaterServiceModel.fromEntity(WaterServiceEntity entity) {
    return WaterServiceModel(
      id: entity.id,
      machineName: entity.machineName,
      address: entity.address,
      date: entity.date,
      timeSlot: entity.timeSlot,
      description: entity.description,
      status: entity.status,
      customerName: entity.customerName,
      phone: entity.phone,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'machineModel': machineName,
      'customerName': customerName ?? 'App User',
      'phone': phone ?? 'N/A',
      'address': address,
      'appointmentDate': date,
      'appointmentTime': timeSlot,
      'problemDetails': description,
      'status': status.isNotEmpty ? status : 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
