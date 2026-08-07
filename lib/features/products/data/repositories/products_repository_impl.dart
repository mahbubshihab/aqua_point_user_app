import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_mock_datasource.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource remoteDatasource;
  final ProductsMockDatasource? mockDatasource;

  ProductsRepositoryImpl({
    ProductsRemoteDatasource? remoteDatasource,
    this.mockDatasource,
  }) : remoteDatasource = remoteDatasource ?? ProductsRemoteDatasourceImpl();

  @override
  Future<List<ProductEntity>> getProducts({String? targetCategory}) async {
    try {
      final remoteProducts = await remoteDatasource.fetchProducts(targetCategory: targetCategory);
      if (remoteProducts.isNotEmpty) return remoteProducts;
    } catch (_) {}
    return mockDatasource?.fetchProducts() ?? ProductsMockDatasource.defaultProducts;
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
      if (categories.isNotEmpty) return categories;
    } catch (_) {}
    return mockDatasource?.fetchCategories() ?? ProductsMockDatasource.defaultCategories;
  }

  @override
  Future<void> addProduct(ProductEntity product, {String? userId}) async {
    await remoteDatasource.addCustomProduct(product, userId: userId);
  }
}
