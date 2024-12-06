import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/base_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends BaseBloc<SplashEvent, SplashState> {
  final CheckAuthStatusUseCase _checkAuthStatus;

  SplashBloc({
    required CheckAuthStatusUseCase checkAuthStatus,
  })  : _checkAuthStatus = checkAuthStatus,
        super(SplashInitial()) {
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
  }

  Future<void> _onCheckAuthenticationStatus(
    CheckAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2)); // Minimum splash duration

    final result = await _checkAuthStatus(NoParams());

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          emit(SplashError(message: 'Sem conexão com a internet'));
        } else if (failure is AuthFailure) {
          emit(SplashUnauthenticated());
        } else {
          emit(SplashError(message: failure.message));
        }
      },
      (isAuthenticated) {
        if (isAuthenticated) {
          emit(SplashAuthenticated());
        } else {
          emit(SplashUnauthenticated());
        }
      },
    );
  }
}
