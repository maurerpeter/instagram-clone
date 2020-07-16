part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CreateCommentLoading extends CommentState {}

class CreateCommentError extends CommentState {
  final String message;

  const CreateCommentError({@required this.message});

  @override
  List<Object> get props => [message];
}

class CommentCreated extends CommentState {}

class GetCommentsLoading extends CommentState {}

class GetCommentsError extends CommentState {
  final String message;

  const GetCommentsError({@required this.message});

  @override
  List<Object> get props => [message];
}

class CommentsLoaded extends CommentState {
  final List<Comment> comments;

  const CommentsLoaded({@required this.comments});

  @override
  List<Object> get props => [comments];
}
