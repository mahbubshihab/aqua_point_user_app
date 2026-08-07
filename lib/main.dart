import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/splash/presentation/pages/custom_splash_page.dart';
import 'features/inbox_support/data/datasources/inbox_support_mock_datasource.dart';
import 'features/inbox_support/data/repositories/inbox_support_repository_impl.dart';
import 'features/inbox_support/domain/repositories/inbox_support_repository.dart';
import 'features/inbox_support/presentation/bloc/inbox_support_bloc.dart';
import 'features/inbox_support/presentation/bloc/inbox_support_event.dart';
import 'features/products/data/datasources/products_remote_datasource.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/domain/repositories/products_repository.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/bloc/products_event.dart';
import 'features/services/data/datasources/services_remote_datasource.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/domain/repositories/services_repository.dart';
import 'features/services/presentation/bloc/services_bloc.dart';
import 'features/services/presentation/bloc/services_event.dart';

import 'features/profile_rewards/data/datasources/profile_rewards_mock_datasource.dart';
import 'features/profile_rewards/data/repositories/profile_rewards_repository_impl.dart';
import 'features/profile_rewards/domain/repositories/profile_rewards_repository.dart';
import 'features/profile_rewards/presentation/bloc/profile_rewards_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/orders/presentation/bloc/cart_bloc.dart';
import 'features/profile_rewards/presentation/bloc/profile_rewards_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRepository = HomeRepositoryImpl(
      datasource: HomeRemoteDatasource(),
    );
    final servicesRepository = ServicesRepositoryImpl(
      remoteDatasource: ServicesRemoteDatasourceImpl(),
    );
    final productsRepository = ProductsRepositoryImpl(
      remoteDatasource: ProductsRemoteDatasourceImpl(),
    );
    final inboxSupportRepository = InboxSupportRepositoryImpl(
      datasource: InboxSupportMockDatasource(),
    );
    final profileRewardsRepository = ProfileRewardsRepositoryImpl(
      datasource: ProfileRewardsMockDatasource(),
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServicesRepository>.value(
          value: servicesRepository,
        ),
        RepositoryProvider<ProductsRepository>.value(
          value: productsRepository,
        ),
        RepositoryProvider<InboxSupportRepository>.value(
          value: inboxSupportRepository,
        ),
        RepositoryProvider<ProfileRewardsRepository>.value(
          value: profileRewardsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
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
          BlocProvider<InboxSupportBloc>(
            create: (context) => InboxSupportBloc(repository: inboxSupportRepository)
              ..add(const LoadInboxData()),
          ),
          BlocProvider<ProfileRewardsBloc>(
            create: (context) => ProfileRewardsBloc(repository: profileRewardsRepository)
              ..add(const LoadProfileData()),
          ),
        ],
        child: MaterialApp(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: const CustomSplashPage(),
        ),
      ),
    );
  }
}
