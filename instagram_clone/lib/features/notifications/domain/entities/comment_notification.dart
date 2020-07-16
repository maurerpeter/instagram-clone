import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class CommentNotification extends Equatable implements Notification {
  final PartialUser from;
  final String content;

  const CommentNotification({@required this.from, @required this.content});

  factory CommentNotification.fromJson(Map<String, dynamic> json) {
    final reaction = json['comment'];
    return CommentNotification(
      from: PartialUserModel.fromJson(reaction['from']),
      content: reaction['content'],
    );
  }

  @override
  String getContent() {
    return '${from.username} commented: $content..';
  }

  @override
  PartialUser getSender() {
    return from;
  }

  @override
  List<Object> get props => [from];
}
