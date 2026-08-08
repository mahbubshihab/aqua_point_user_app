import '../../../products/domain/entities/category_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../entities/banner_entity.dart';
import '../entities/blog_entity.dart';
import '../entities/company_info_entity.dart';
import '../entities/hydration_entity.dart';
import '../entities/water_quality_entity.dart';

abstract class HomeRepository {
  Future<List<BannerEntity>> getBanners();
  Future<CompanyInfoEntity> getCompanyInfo();
  Future<HydrationEntity> getHydrationData();
  Future<WaterQualityEntity> getWaterQualityData();
  Future<List<BlogEntity>> getBlogs();
  Future<List<CategoryEntity>> getCategories();
  Future<List<ProductEntity>> getProductsByType(String type, {int limit = 10});
}

