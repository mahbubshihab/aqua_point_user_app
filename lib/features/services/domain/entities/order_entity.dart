import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String title;
  final String date;
  final double amount;
  final String status;

  const OrderEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, date, amount, status];
}
