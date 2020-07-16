import 'package:instagram_clone/features/posts/domain/entities/post.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:meta/meta.dart';

class PostModel extends Post {
  const PostModel({
    @required String id,
    @required String description,
    @required String type,
    @required String mediaUrl,
    @required PartialUserModel user,
  }) : super(
          id: id,
          description: description,
          type: type,
          mediaUrl: mediaUrl,
          user: user,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      description: json['description'],
      type: json['type'],
      mediaUrl: json['mediaUrl'],
      user: PartialUserModel.fromJson(json['user']),
    );
  }
}
