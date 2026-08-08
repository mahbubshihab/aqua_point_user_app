import '../../../products/domain/entities/category_entity.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/company_info_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource datasource;

  HomeRepositoryImpl({required this.datasource});

  @override
  Future<List<BannerEntity>> getBanners() => datasource.fetchBanners();

  @override
  Future<CompanyInfoEntity> getCompanyInfo() => datasource.fetchCompanyInfo();

  @override
  Future<HydrationEntity> getHydrationData() => datasource.fetchHydrationData();

  @override
  Future<WaterQualityEntity> getWaterQualityData() => datasource.fetchWaterQualityData();

  @override
  Future<List<BlogEntity>> getBlogs() => datasource.fetchBlogs();

  @override
  Future<List<CategoryEntity>> getCategories() => datasource.fetchCategories();
}

