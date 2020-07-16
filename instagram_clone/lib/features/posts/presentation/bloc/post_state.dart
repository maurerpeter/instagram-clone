part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class GetPostsLoading extends PostState {}

class CreatePostLoading extends PostState {}

class GetPostsError extends PostState {
  final String message;

  const GetPostsError({@required this.message});

  @override
  List<Object> get props => [message];
}

class CreatePostError extends PostState {
  final String message;

  const CreatePostError({@required this.message});

  @override
  List<Object> get props => [message];
}

class PostsLoaded extends PostState {
  final List<Post> posts;

  const PostsLoaded({@required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostCreated extends PostState {}
