import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductsEvent {
  const LoadProducts();
}

class AddProduct extends ProductsEvent {
  final String name;
  final String? imagePath;
  final String? category;
  final double? price;
  final String? warranty;
  final String? description;

  const AddProduct(
    this.name, [
    this.imagePath,
    this.category,
    this.price,
    this.warranty,
    this.description,
  ]);

  @override
  List<Object?> get props => [name, imagePath, category, price, warranty, description];
}
