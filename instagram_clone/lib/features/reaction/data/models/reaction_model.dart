import 'package:instagram_clone/features/posts/data/models/post_model.dart';
import 'package:instagram_clone/features/reaction/domain/entities/reaction.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:meta/meta.dart';

class ReactionModel extends Reaction {
  const ReactionModel({
    @required String id,
    @required PartialUserModel from,
    @required PostModel post,
    @required String type,
  }) : super(
          id: id,
          from: from,
          post: post,
          type: type,
        );

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      id: json['id'],
      from: PartialUserModel.fromJson(json['user']),
      post: PostModel.fromJson(json['post']),
      type: json['type'],
    );
  }
}
