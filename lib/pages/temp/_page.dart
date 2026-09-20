import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '_bloc.dart';
import '_event.dart';
import '_state.dart';

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TempBloc()..add(const TempStarted()),
      child: const TempView(),
    );
  }
}

class TempView extends StatelessWidget {
  const TempView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TempBloc, TempState>(
        builder: (context, state) {
          return switch (state) {
            TempInitial() => const Center(child: CircularProgressIndicator()),
            TempReady() => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
