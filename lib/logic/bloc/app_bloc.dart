import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppStarted extends AppEvent {
  const AppStarted();
}

sealed class AppState {
  const AppState();
}

final class AppInitial extends AppState {
  const AppInitial();
}

final class AppReady extends AppState {
  const AppReady();
}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<AppStarted>((event, emit) => emit(const AppReady()));
  }
}
