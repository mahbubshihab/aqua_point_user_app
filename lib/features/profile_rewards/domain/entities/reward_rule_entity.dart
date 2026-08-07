import 'package:equatable/equatable.dart';

class RewardRuleEntity extends Equatable {
  final String title;
  final String description;
  final int points;
  final String iconName;

  const RewardRuleEntity({
    required this.title,
    required this.description,
    required this.points,
    required this.iconName,
  });

  @override
  List<Object?> get props => [title, description, points, iconName];
}
