import 'package:instagram_clone/features/users/domain/entities/user.dart';
import 'package:meta/meta.dart';

class UserModel extends User {
  const UserModel({
    @required String id,
    @required String email,
    @required String username,
    @required String profilePictureUrl,
    @required int numberOfFollowers,
  }) : super(
          id: id,
          email: email,
          username: username,
          profilePictureUrl: profilePictureUrl,
          numberOfFollowers: numberOfFollowers,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'],
      username: json['username'],
      profilePictureUrl: json['profilePictureUrl'],
      numberOfFollowers: json['numberOfFollowers'],
    );
  }
}
