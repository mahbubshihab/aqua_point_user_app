import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/datasources/home_mock_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/home/presentation/pages/main_shell_page.dart';

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

    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(repository: homeRepository)
          ..add(const LoadHomeData()),
        child: const MainShellPage(),
      ),
    );
  }
}
