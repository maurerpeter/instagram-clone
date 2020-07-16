part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class GetPosts extends PostEvent {
  final int limit;
  final int offset;

  const GetPosts({@required this.limit, @required this.offset});

  @override
  List<Object> get props => [limit, offset];
}

class CreatePost extends PostEvent {
  final String description;
  final File media;

  const CreatePost({@required this.description, @required this.media});

  @override
  List<Object> get props => [description, media];
}
