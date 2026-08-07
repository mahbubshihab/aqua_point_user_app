import 'package:equatable/equatable.dart';

class HydrationEntity extends Equatable {
  final int currentGlasses;
  final int targetGlasses;

  const HydrationEntity({
    required this.currentGlasses,
    required this.targetGlasses,
  });

  HydrationEntity copyWith({
    int? currentGlasses,
    int? targetGlasses,
  }) {
    return HydrationEntity(
      currentGlasses: currentGlasses ?? this.currentGlasses,
      targetGlasses: targetGlasses ?? this.targetGlasses,
    );
  }

  @override
  List<Object?> get props => [currentGlasses, targetGlasses];
}
