import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const BaseState({
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage];
}

class InitialState extends BaseState {
  const InitialState() : super();
}

class LoadingState extends BaseState {
  const LoadingState() : super(isLoading: true);
}

class ErrorState extends BaseState {
  const ErrorState(String message) : super(errorMessage: message);
}

class SuccessState<T> extends BaseState {
  final T data;

  const SuccessState(this.data) : super();

  @override
  List<Object?> get props => [...super.props, data];
}
