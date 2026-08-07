import '../entities/blog_entity.dart';
import '../entities/hydration_entity.dart';
import '../entities/water_quality_entity.dart';

abstract class HomeRepository {
  Future<HydrationEntity> getHydrationData();
  Future<WaterQualityEntity> getWaterQualityData();
  Future<List<BlogEntity>> getBlogs();
}
