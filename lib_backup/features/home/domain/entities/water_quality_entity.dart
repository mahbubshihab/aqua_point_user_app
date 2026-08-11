import 'package:equatable/equatable.dart';

class WaterQualityEntity extends Equatable {
  final int tds;
  final String status;
  final double iron;
  final double ph;
  final String hardness;

  const WaterQualityEntity({
    required this.tds,
    required this.status,
    required this.iron,
    required this.ph,
    required this.hardness,
  });

  @override
  List<Object?> get props => [tds, status, iron, ph, hardness];
}
