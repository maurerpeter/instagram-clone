part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

class CommentToPost extends CommentEvent {
  final String postId;
  final String content;

  const CommentToPost({@required this.postId, @required this.content});

  @override
  List<Object> get props => [postId, content];
}

class GetComments extends CommentEvent {
  final String postId;

  const GetComments({@required this.postId});

  @override
  List<Object> get props => [postId];
}
