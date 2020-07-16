import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/users/domain/entities/user.dart';
import 'package:instagram_clone/features/users/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository});

  @override
  UserState get initialState => UserInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is GetUsers) {
      yield GetUsersLoading();
      final failureOrUsers = await userRepository.getUsers(event.username);
      yield failureOrUsers.fold(
        (failure) => GetUsersError(message: _mapFailureToMessage(failure)),
        (users) => UsersLoaded(users: users),
      );
    } else
    //
    if (event is GetFollowedUsers) {
      yield GetFollowedUsersLoading();
      final failureOrUsers =
          await userRepository.getFollowedUsers(event.username);
      yield failureOrUsers.fold(
        (failure) => GetUsersError(message: _mapFailureToMessage(failure)),
        (users) => FollowedUsersLoaded(users: users),
      );
    } else
    //
    if (event is PatchUser) {
      yield PatchUserLoading();
      final failureOrSuccess =
          await userRepository.updateProfilePicture(event.profilePicture);
      yield failureOrSuccess.fold(
        (failure) => PatchUserError(message: _mapFailureToMessage(failure)),
        (users) => PatchUserSuccess(),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
