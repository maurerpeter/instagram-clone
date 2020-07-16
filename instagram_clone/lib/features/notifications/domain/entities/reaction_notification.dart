import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class ReactionNotification extends Equatable implements Notification {
  final PartialUser from;
  final String type;

  const ReactionNotification({@required this.from, @required this.type});

  factory ReactionNotification.fromJson(Map<String, dynamic> json) {
    final reaction = json['reaction'];
    return ReactionNotification(
      from: PartialUserModel.fromJson(reaction['from']),
      type: reaction['type'],
    );
  }

  @override
  String getContent() {
    return '${from.username} reacted to your post with $type';
  }

  @override
  PartialUser getSender() {
    return from;
  }

  @override
  List<Object> get props => [from];
}
