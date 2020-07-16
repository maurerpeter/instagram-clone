part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUsers extends UserEvent {
  final String username;

  const GetUsers(this.username);

  @override
  List<Object> get props => [username];
}

class GetFollowedUsers extends UserEvent {
  final String username;

  const GetFollowedUsers(this.username);

  @override
  List<Object> get props => [username];
}

class PatchUser extends UserEvent {
  final File profilePicture;

  const PatchUser({@required this.profilePicture});

  @override
  List<Object> get props => [profilePicture];
}
