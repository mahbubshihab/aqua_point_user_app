import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String id;
  final String invoiceNumber;
  final String date;
  final double amount;
  final String status;

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => [id, invoiceNumber, date, amount, status];
}
