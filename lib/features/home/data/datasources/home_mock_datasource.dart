import '../../domain/entities/blog_entity.dart';
import '../../domain/entities/hydration_entity.dart';
import '../../domain/entities/water_quality_entity.dart';

class HomeMockDatasource {
  Future<HydrationEntity> fetchHydrationData() async {
    return const HydrationEntity(
      currentGlasses: 0,
      targetGlasses: 8,
    );
  }

  Future<WaterQualityEntity> fetchWaterQualityData() async {
    return const WaterQualityEntity(
      tds: 0,
      status: 'N/A',
      iron: 0.0,
      ph: 7.0,
      hardness: 'N/A',
    );
  }

  Future<List<BlogEntity>> fetchBlogs() async {
    return const [];
  }
}
