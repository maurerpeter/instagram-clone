part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class GetUsersLoading extends UserState {}

class GetFollowedUsersLoading extends UserState {}

class GetUsersError extends UserState {
  final String message;

  const GetUsersError({@required this.message});

  @override
  List<Object> get props => [message];
}

class GetFollowedUsersError extends UserState {
  final String message;

  const GetFollowedUsersError({@required this.message});

  @override
  List<Object> get props => [message];
}

class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded({@required this.users});

  @override
  List<Object> get props => [users];
}

class FollowedUsersLoaded extends UserState {
  final List<User> users;

  const FollowedUsersLoaded({@required this.users});

  @override
  List<Object> get props => [users];
}

class PatchUserLoading extends UserState {}

class PatchUserError extends UserState {
  final String message;

  const PatchUserError({@required this.message});

  @override
  List<Object> get props => [message];
}

class PatchUserSuccess extends UserState {}
