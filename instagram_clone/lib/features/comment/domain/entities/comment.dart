import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/posts/domain/entities/post.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class Comment extends Equatable {
  final String id;
  final PartialUser from;
  final Post post;
  final String content;

  const Comment({
    @required this.id,
    @required this.from,
    @required this.post,
    @required this.content,
  });

  @override
  List<Object> get props => [id, from, post, content];
}
