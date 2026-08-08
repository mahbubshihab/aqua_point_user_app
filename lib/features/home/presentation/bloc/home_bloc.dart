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
    emit(const HomeLoading());
    try {
      List<BannerEntity> banners = [];
      try {
        banners = await repository.getBanners();
      } catch (_) {
        banners = [];
      }

      CompanyInfoEntity companyInfo;
      try {
        companyInfo = await repository.getCompanyInfo();
      } catch (_) {
        companyInfo = const CompanyInfoEntity();
      }

      List<CategoryEntity> categories = [];
      try {
        categories = await repository.getCategories();
      } catch (_) {
        categories = [];
      }

      List<ProductEntity> openTypeProducts = [];
      try {
        openTypeProducts = await repository.getProductsByType('open_type', limit: 10);
      } catch (_) {
        openTypeProducts = [];
      }

      List<ProductEntity> boxTypeProducts = [];
      try {
        boxTypeProducts = await repository.getProductsByType('box_type', limit: 10);
      } catch (_) {
        boxTypeProducts = [];
      }

      List<ProductEntity> hotColdNormalProducts = [];
      try {
        hotColdNormalProducts = await repository.getProductsByType('hot_cold_normal', limit: 10);
      } catch (_) {
        hotColdNormalProducts = [];
      }

      List<ProductEntity> cabinetTypeProducts = [];
      try {
        cabinetTypeProducts = await repository.getProductsByType('cabinet_type', limit: 10);
      } catch (_) {
        cabinetTypeProducts = [];
      }

      final hydration = await repository.getHydrationData();
      final waterQuality = await repository.getWaterQualityData();
      final blogs = await repository.getBlogs();

      emit(HomeLoaded(
        tabIndex: 0,
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
      emit(HomeError(e.toString()));
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
