import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String title;
  final String date;
  final double amount;
  final String status;
  final String? imageUrl;
  final String? productId;
  final List<Map<String, dynamic>>? items;
  final String? customerName;
  final String? phone;
  final String? address;
  final String? paymentMethod;
  final String? deliveryInstructions;
  final double? subtotal;
  final double? shippingFee;

  const OrderEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.imageUrl,
    this.productId,
    this.items,
    this.customerName,
    this.phone,
    this.address,
    this.paymentMethod,
    this.deliveryInstructions,
    this.subtotal,
    this.shippingFee,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        amount,
        status,
        imageUrl,
        productId,
        items,
        customerName,
        phone,
        address,
        paymentMethod,
        deliveryInstructions,
        subtotal,
        shippingFee,
      ];
}

