import 'package:bloc/bloc.dart';
import '../../../../core/bloc/base_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignupUseCase signupUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.signupUseCase,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthenticationStatusRequested>(_onAuthenticationStatusRequested);
    add(AuthenticationStatusRequested());
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    emit(
      result.fold(
        (failure) => AuthError(message: failure.message),
        (user) => AuthAuthenticated(user: user),
      ),
    );
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signupUseCase(
      SignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    emit(
      result.fold(
        (failure) => AuthError(message: failure.message),
        (user) => AuthAuthenticated(user: user),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    emit(
      result.fold(
        (failure) => AuthError(message: failure.message),
        (_) => AuthUnauthenticated(),
      ),
    );
  }

  Future<void> _onAuthenticationStatusRequested(
    AuthenticationStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    emit(
      result.fold(
        (failure) => AuthError(message: failure.message),
        (user) => user != null
            ? AuthAuthenticated(user: user)
            : AuthUnauthenticated(),
      ),
    );
  }
}
