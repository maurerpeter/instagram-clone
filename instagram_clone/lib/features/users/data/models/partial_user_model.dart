import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class PartialUserModel extends PartialUser {
  const PartialUserModel({
    @required String id,
    @required String username,
    @required String profilePictureUrl,
  }) : super(
          id: id,
          username: username,
          profilePictureUrl: profilePictureUrl,
        );

  factory PartialUserModel.fromJson(Map<String, dynamic> json) {
    return PartialUserModel(
      id: json['id'] as String,
      username: json['username'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}
