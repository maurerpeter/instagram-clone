import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/reaction/domain/entities/reaction.dart';
import 'package:instagram_clone/features/reaction/domain/repositories/reaction_repository.dart';
import 'package:meta/meta.dart';

part 'reaction_event.dart';
part 'reaction_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class ReactionBloc extends Bloc<ReactionEvent, ReactionState> {
  final ReactionRepository reactionRepository;

  ReactionBloc({@required this.reactionRepository});

  @override
  ReactionState get initialState => ReactionInitial();

  @override
  Stream<ReactionState> mapEventToState(
    ReactionEvent event,
  ) async* {
    if (event is ReactToPost) {
      yield CreateReactionLoading();
      final failureOrReactionCreated = await reactionRepository.createReaction(
        postId: event.postId,
        type: event.type,
      );
      yield failureOrReactionCreated.fold(
        (failure) =>
            CreateReactionError(message: _mapFailureToMessage(failure)),
        (_) => ReactionCreated(),
      );
    } else //
    if (event is GetReactions) {
      yield GetReactionsLoading();
      final failureOrPosts =
          await reactionRepository.getReactions(postId: event.postId);
      yield failureOrPosts.fold(
        (failure) => GetReactionsError(message: _mapFailureToMessage(failure)),
        (reactions) => ReactionsLoaded(reactions: reactions),
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
