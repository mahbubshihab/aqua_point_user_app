import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_mock_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeMockDatasource datasource;

  HomeRepositoryImpl({required this.datasource});

  @override
  Future<HydrationEntity> getHydrationData() => datasource.fetchHydrationData();

  @override
  Future<WaterQualityEntity> getWaterQualityData() => datasource.fetchWaterQualityData();

  @override
  Future<List<BlogEntity>> getBlogs() => datasource.fetchBlogs();
}
