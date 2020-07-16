import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:instagram_clone/features/users/data/models/partial_user_model.dart';
import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';
import 'package:meta/meta.dart';

class FollowNotification extends Equatable implements Notification {
  final PartialUser from;

  const FollowNotification({@required this.from});

  factory FollowNotification.fromJson(Map<String, dynamic> json) {
    return FollowNotification(
      from: PartialUserModel.fromJson(json['follower']),
    );
  }

  @override
  String getContent() {
    return '${from.username} started following you';
  }

  @override
  PartialUser getSender() {
    return from;
  }

  @override
  List<Object> get props => [from];
}
