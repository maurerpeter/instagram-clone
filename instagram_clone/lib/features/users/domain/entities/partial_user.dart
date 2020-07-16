import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PartialUser extends Equatable {
  final String id;
  final String username;
  final String profilePictureUrl;

  const PartialUser({
    @required this.id,
    @required this.username,
    @required this.profilePictureUrl,
  });

  @override
  List<Object> get props => [id, username, profilePictureUrl];
}
