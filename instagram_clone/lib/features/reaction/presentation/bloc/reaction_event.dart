part of 'reaction_bloc.dart';

abstract class ReactionEvent extends Equatable {
  const ReactionEvent();
}

class ReactToPost extends ReactionEvent {
  final String postId;
  final String type;

  const ReactToPost({@required this.postId, @required this.type});

  @override
  List<Object> get props => [postId, type];
}

class GetReactions extends ReactionEvent {
  final String postId;

  const GetReactions({@required this.postId});

  @override
  List<Object> get props => [postId];
}
