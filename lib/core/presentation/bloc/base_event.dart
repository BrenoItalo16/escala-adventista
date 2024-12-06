import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

class InitEvent extends BaseEvent {
  const InitEvent();
}

class RefreshEvent extends BaseEvent {
  const RefreshEvent();
}
