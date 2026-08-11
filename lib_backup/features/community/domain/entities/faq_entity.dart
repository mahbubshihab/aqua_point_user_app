import 'package:equatable/equatable.dart';

class FaqEntity extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String? category;
  final DateTime? createdAt;

  const FaqEntity({
    required this.id,
    required this.question,
    required this.answer,
    this.category,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, question, answer, category, createdAt];
}
