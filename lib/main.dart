import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/datasources/home_mock_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/home/presentation/pages/main_shell_page.dart';
import 'features/products/data/datasources/products_mock_datasource.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/domain/repositories/products_repository.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/bloc/products_event.dart';
import 'features/services/data/datasources/services_mock_datasource.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/domain/repositories/services_repository.dart';
import 'features/services/presentation/bloc/services_bloc.dart';
import 'features/services/presentation/bloc/services_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRepository = HomeRepositoryImpl(
      datasource: HomeMockDatasource(),
    );
    final servicesRepository = ServicesRepositoryImpl(
      datasource: ServicesMockDatasource(),
    );
    final productsRepository = ProductsRepositoryImpl(
      datasource: ProductsMockDatasource(),
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServicesRepository>.value(
          value: servicesRepository,
        ),
        RepositoryProvider<ProductsRepository>.value(
          value: productsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(repository: homeRepository)
              ..add(const LoadHomeData()),
          ),
          BlocProvider<ServicesBloc>(
            create: (context) => ServicesBloc(repository: servicesRepository)
              ..add(const LoadServicesHistory()),
          ),
          BlocProvider<ProductsBloc>(
            create: (context) => ProductsBloc(repository: productsRepository)
              ..add(const LoadProducts()),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const MainShellPage(),
        ),
      ),
    );
  }
}
