import '../../domain/entities/reward_rule_entity.dart';

class RewardRuleModel extends RewardRuleEntity {
  const RewardRuleModel({
    required super.title,
    required super.description,
    required super.points,
    required super.iconName,
  });

  factory RewardRuleModel.fromJson(Map<String, dynamic> json) {
    return RewardRuleModel(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      iconName: json['iconName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'points': points,
      'iconName': iconName,
    };
  }
}
