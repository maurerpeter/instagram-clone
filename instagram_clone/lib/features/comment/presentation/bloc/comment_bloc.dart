import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/comment/domain/entities/comment.dart';
import 'package:instagram_clone/features/comment/domain/repositories/comment_repository.dart';
import 'package:meta/meta.dart';

part 'comment_event.dart';
part 'comment_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;

  CommentBloc({@required this.commentRepository});

  @override
  CommentState get initialState => CommentInitial();

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if (event is CommentToPost) {
      yield CreateCommentLoading();
      final failureOrCommentCreated = await commentRepository.createComment(
        postId: event.postId,
        content: event.content,
      );
      yield failureOrCommentCreated.fold(
        (failure) => CreateCommentError(message: _mapFailureToMessage(failure)),
        (_) => CommentCreated(),
      );
    } else //
    if (event is GetComments) {
      yield GetCommentsLoading();
      final failureOrPosts =
          await commentRepository.getComments(postId: event.postId);
      yield failureOrPosts.fold(
        (failure) => GetCommentsError(message: _mapFailureToMessage(failure)),
        (comments) => CommentsLoaded(comments: comments),
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
