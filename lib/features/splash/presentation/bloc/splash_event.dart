part of 'splash_bloc.dart';

abstract class SplashEvent extends BaseEvent {
  const SplashEvent();
}

class CheckAuthenticationStatus extends SplashEvent {}
