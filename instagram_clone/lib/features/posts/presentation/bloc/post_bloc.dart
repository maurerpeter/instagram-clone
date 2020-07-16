import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/posts/domain/entities/post.dart';
import 'package:instagram_clone/features/posts/domain/repositories/post_repository.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({@required this.postRepository});

  @override
  PostState get initialState => PostInitial();

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is GetPosts) {
      yield GetPostsLoading();
      final failureOrPosts = await postRepository.getPosts(
        limit: event.limit,
        offset: event.offset,
      );
      yield failureOrPosts.fold(
        (failure) => GetPostsError(message: _mapFailureToMessage(failure)),
        (posts) => PostsLoaded(posts: posts),
      );
    } else
    //
    if (event is CreatePost) {
      yield CreatePostLoading();
      final failureOrPostCreated = await postRepository.createPost(
        description: event.description,
        media: event.media,
      );
      yield failureOrPostCreated.fold(
        (failure) => CreatePostError(message: _mapFailureToMessage(failure)),
        (_) => PostCreated(),
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
