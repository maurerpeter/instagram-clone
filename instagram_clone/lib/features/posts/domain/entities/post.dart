import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class Post extends Equatable {
  final String id;
  final String description;
  final String type; // =["image","video"]
  final String mediaUrl;
  final PartialUser user;

  const Post({
    @required this.id,
    @required this.description,
    @required this.type,
    @required this.mediaUrl,
    @required this.user,
  });

  @override
  List<Object> get props => [id, description, type, mediaUrl, user];
}
