import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/category_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/company_info_entity.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<IncrementHydration>(_onIncrementHydration);
    on<DecrementHydration>(_onDecrementHydration);
    on<SelectTab>(_onSelectTab);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // Keep showing previous loaded state during refresh if available
    if (state is! HomeLoaded) {
      emit(const HomeLoading());
    }
    
    try {
      final results = await Future.wait([
        repository.getBanners().catchError((_) => <BannerEntity>[]),
        repository.getCompanyInfo().catchError((_) => const CompanyInfoEntity()),
        repository.getCategories().catchError((_) => <CategoryEntity>[]),
        repository.getProductsByType('open_type', limit: 10).catchError((_) => <ProductEntity>[]),
        repository.getProductsByType('box_type', limit: 10).catchError((_) => <ProductEntity>[]),
        repository.getProductsByType('hot_cold_normal', limit: 10).catchError((_) => <ProductEntity>[]),
        repository.getProductsByType('cabinet_type', limit: 10).catchError((_) => <ProductEntity>[]),
        repository.getHydrationData().catchError((_) => const HydrationEntity(currentGlasses: 0, targetGlasses: 8)),
        repository.getWaterQualityData().catchError((_) => const WaterQualityEntity(tds: 18, status: 'Excellent')),
        repository.getBlogs().catchError((_) => <BlogEntity>[]),
      ]);

      final banners = results[0] as List<BannerEntity>;
      final companyInfo = results[1] as CompanyInfoEntity;
      final categories = results[2] as List<CategoryEntity>;
      final openTypeProducts = results[3] as List<ProductEntity>;
      final boxTypeProducts = results[4] as List<ProductEntity>;
      final hotColdNormalProducts = results[5] as List<ProductEntity>;
      final cabinetTypeProducts = results[6] as List<ProductEntity>;
      final hydration = results[7] as HydrationEntity;
      final waterQuality = results[8] as WaterQualityEntity;
      final blogs = results[9] as List<BlogEntity>;

      int currentTab = 0;
      if (state is HomeLoaded) {
        currentTab = (state as HomeLoaded).tabIndex;
      }

      emit(HomeLoaded(
        tabIndex: currentTab,
        banners: banners,
        companyInfo: companyInfo,
        hydration: hydration,
        waterQuality: waterQuality,
        blogs: blogs,
        categories: categories,
        openTypeProducts: openTypeProducts,
        boxTypeProducts: boxTypeProducts,
        hotColdNormalProducts: hotColdNormalProducts,
        cabinetTypeProducts: cabinetTypeProducts,
      ));
    } catch (e) {
      if (state is! HomeLoaded) {
        emit(HomeError(e.toString()));
      }
    }
  }


  void _onIncrementHydration(
    IncrementHydration event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final newCurrent = currentState.hydration.currentGlasses + 1;
      final updatedHydration = currentState.hydration.copyWith(
        currentGlasses: newCurrent,
      );
      emit(currentState.copyWith(hydration: updatedHydration));
    }
  }

  void _onDecrementHydration(
    DecrementHydration event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      if (currentState.hydration.currentGlasses > 0) {
        final newCurrent = currentState.hydration.currentGlasses - 1;
        final updatedHydration = currentState.hydration.copyWith(
          currentGlasses: newCurrent,
        );
        emit(currentState.copyWith(hydration: updatedHydration));
      }
    }
  }

  void _onSelectTab(
    SelectTab event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(tabIndex: event.tabIndex));
    }
  }
}
