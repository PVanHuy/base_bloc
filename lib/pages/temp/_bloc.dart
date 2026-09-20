import 'package:flutter_bloc/flutter_bloc.dart';

import '_event.dart';
import '_state.dart';

class TempBloc extends Bloc<TempEvent, TempState> {
  TempBloc() : super(const TempInitial()) {
    on<TempStarted>((event, emit) {
      emit(const TempReady());
    });
  }
}
