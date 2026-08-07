import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository repository;

  ProductsBloc({required this.repository}) : super(const ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    try {
      final shopProducts = await repository.getProducts();
      final customProducts = await repository.getCustomProducts();
      final categories = await repository.getCategories();

      // De-duplicate products by ID if custom and shop overlap
      final Set<String> seenIds = {};
      final List<ProductEntity> allProducts = [];

      for (final p in [...shopProducts, ...customProducts]) {
        if (!seenIds.contains(p.id)) {
          seenIds.add(p.id);
          allProducts.add(p);
        }
      }

      emit(ProductsLoaded(allProducts, categories: categories));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductAdding());
    try {
      final now = DateTime.now();
      final dayStr = now.day.toString().padLeft(2, '0');
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      final monthStr = months[now.month - 1];
      final dateFormatted = '$dayStr $monthStr ${now.year}';

      final product = ProductEntity(
        id: 'CUST-${now.millisecondsSinceEpoch}',
        name: event.name,
        photoUrl: event.imagePath,
        warrantyDetails: '1 Year Warranty',
        purchaseDate: dateFormatted,
        isCustom: true,
      );

      await repository.addProduct(product);
      emit(const ProductAddSuccess());

      final shopProducts = await repository.getProducts();
      final updatedCustom = await repository.getCustomProducts();
      final categories = await repository.getCategories();
      final Set<String> seenIds = {};
      final List<ProductEntity> allProducts = [];
      for (final p in [...shopProducts, ...updatedCustom]) {
        if (!seenIds.contains(p.id)) {
          seenIds.add(p.id);
          allProducts.add(p);
        }
      }
      emit(ProductsLoaded(allProducts, categories: categories));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
