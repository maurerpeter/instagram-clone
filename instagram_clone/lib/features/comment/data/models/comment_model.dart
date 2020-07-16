import 'package:instagram_clone/features/comment/domain/entities/comment.dart';
import 'package:instagram_clone/features/posts/data/models/post_model.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:meta/meta.dart';

class CommentModel extends Comment {
  const CommentModel({
    @required String id,
    @required PartialUserModel from,
    @required PostModel post,
    @required String content,
  }) : super(
          id: id,
          from: from,
          post: post,
          content: content,
        );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      from: PartialUserModel.fromJson(json['from']),
      post: PostModel.fromJson(json['post']),
      content: json['content'],
    );
  }
}
