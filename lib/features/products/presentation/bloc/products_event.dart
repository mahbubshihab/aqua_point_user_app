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

  const AddProduct(this.name, [this.imagePath]);

  @override
  List<Object?> get props => [name, imagePath];
}
