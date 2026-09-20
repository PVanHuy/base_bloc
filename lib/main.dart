import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/bloc/app_bloc.dart';
import 'theme/app_theme_util.dart';
import 'theme/base_theme_data.dart';
import 'ui/pages/home_page.dart';

final AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() {
  runApp(const SomicsOsApp());
}

class SomicsOsApp extends StatelessWidget {
  const SomicsOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()..add(const AppStarted()),
      child: MaterialApp(
        title: 'SOMICS OS',
        debugShowCheckedModeBanner: false,
        theme: themeUtil.getThemeData(),
        home: const HomePage(),
      ),
    );
  }
}
