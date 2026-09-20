import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/app_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOMICS OS')),
      body: Center(
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return switch (state) {
              AppInitial() => const CircularProgressIndicator(),
              AppReady() => const Text('Source base sẵn sàng phát triển'),
            };
          },
        ),
      ),
    );
  }
}
