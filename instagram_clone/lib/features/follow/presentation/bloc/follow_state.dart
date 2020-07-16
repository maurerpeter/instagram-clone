part of 'follow_bloc.dart';

abstract class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object> get props => [];
}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class UnfollowLoading extends FollowState {}

class FollowError extends FollowState {
  final String message;

  const FollowError(this.message);

  @override
  List<Object> get props => [message];
}

class UnfollowError extends FollowState {
  final String message;

  const UnfollowError(this.message);

  @override
  List<Object> get props => [message];
}

class FollowSuccess extends FollowState {}

class UnfollowSuccess extends FollowState {}
