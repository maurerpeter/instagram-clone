import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String profilePictureUrl;
  final int numberOfFollowers;

  const User({
    @required this.id,
    @required this.email,
    @required this.username,
    @required this.profilePictureUrl,
    @required this.numberOfFollowers,
  });

  @override
  List<Object> get props =>
      [id, email, username, profilePictureUrl, numberOfFollowers];
}
