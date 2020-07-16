import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class PostNotification extends Equatable implements Notification {
  final PartialUser from;

  const PostNotification({@required this.from});

  factory PostNotification.fromJson(Map<String, dynamic> json) {
    final post = json['post'];
    return PostNotification(
      from: PartialUserModel.fromJson(post['user']),
    );
  }

  @override
  String getContent() {
    return '${from.username} uploaded a new post';
  }

  @override
  PartialUser getSender() {
    return from;
  }

  @override
  List<Object> get props => [from];
}
