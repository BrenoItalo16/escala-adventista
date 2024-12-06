import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_event.dart';
import 'base_state.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(super.initialState) {
    on<E>((event, emit) async {
      if (event is InitEvent) {
        await _onInit(event as InitEvent, emit);
      } else if (event is RefreshEvent) {
        await _onRefresh(event as RefreshEvent, emit);
      }
    });
  }

  Future<void> _onInit(InitEvent event, Emitter<S> emit) async {
    try {
      emit(LoadingState() as S);
      await onInit(event, emit);
    } catch (error) {
      emit(ErrorState(error.toString()) as S);
    }
  }

  Future<void> _onRefresh(RefreshEvent event, Emitter<S> emit) async {
    await onRefresh(event, emit);
  }

  Future<void> onInit(InitEvent event, Emitter<S> emit) async {}
  Future<void> onRefresh(RefreshEvent event, Emitter<S> emit) async {}

  void emitLoading(Emitter<S> emit) {
    emit(LoadingState() as S);
  }

  void emitError(Emitter<S> emit, String message) {
    emit(ErrorState(message) as S);
  }

  void emitSuccess<T>(Emitter<S> emit, T data) {
    emit(SuccessState<T>(data) as S);
  }
}
