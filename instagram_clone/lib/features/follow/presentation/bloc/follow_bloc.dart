import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/users/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'follow_event.dart';
part 'follow_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final UserRepository userRepository;

  FollowBloc({@required this.userRepository});

  @override
  FollowState get initialState => FollowInitial();

  @override
  Stream<FollowState> mapEventToState(
    FollowEvent event,
  ) async* {
    if (event is FollowUser) {
      yield FollowLoading();
      final failureOrUnit = await userRepository.followUser(event.id);
      yield failureOrUnit.fold(
        (failure) => FollowError(_mapFailureToMessage(failure)),
        (_) => FollowSuccess(),
      );
    } else
    //
    if (event is UnfollowUser) {
      yield UnfollowLoading();
      final failureOrUnit = await userRepository.unfollowUser(event.id);
      yield failureOrUnit.fold(
        (failure) => UnfollowError(_mapFailureToMessage(failure)),
        (_) => UnfollowSuccess(),
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
