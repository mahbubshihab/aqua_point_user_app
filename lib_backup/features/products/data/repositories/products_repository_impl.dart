import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource remoteDatasource;

  ProductsRepositoryImpl({
    ProductsRemoteDatasource? remoteDatasource,
  }) : remoteDatasource = remoteDatasource ?? ProductsRemoteDatasourceImpl();

  @override
  Future<List<ProductEntity>> getProducts({String? targetCategory}) async {
    try {
      final remoteProducts = await remoteDatasource.fetchProducts(targetCategory: targetCategory);
      return remoteProducts;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByType(String type, {int limit = 10}) async {
    try {
      final remoteProducts = await remoteDatasource.fetchProductsByType(type, limit: limit);
      return remoteProducts;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<ProductEntity>> getCustomProducts({String? userId}) async {
    try {
      final customProducts = await remoteDatasource.fetchCustomProducts(userId: userId);
      return customProducts;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<ProductEntity>> getPurchasedProducts({String? userId}) async {
    try {
      final purchasedProducts = await remoteDatasource.fetchPurchasedProducts(userId: userId);
      return purchasedProducts;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final categories = await remoteDatasource.fetchCategories();
      return categories;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addProduct(ProductEntity product, {String? userId}) async {
    await remoteDatasource.addCustomProduct(product, userId: userId);
  }
}

