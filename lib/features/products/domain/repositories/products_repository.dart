import '../entities/category_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts({String? targetCategory});
  Future<List<ProductEntity>> getCustomProducts({String? userId});
  Future<List<ProductEntity>> getPurchasedProducts({String? userId});
  Future<List<CategoryEntity>> getCategories();
  Future<void> addProduct(ProductEntity product, {String? userId});
}

