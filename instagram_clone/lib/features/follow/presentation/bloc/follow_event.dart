part of 'follow_bloc.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();
}

class FollowUser extends FollowEvent {
  final String id;

  const FollowUser(this.id);

  @override
  List<Object> get props => [id];
}

class UnfollowUser extends FollowEvent {
  final String id;

  const UnfollowUser(this.id);

  @override
  List<Object> get props => [id];
}
