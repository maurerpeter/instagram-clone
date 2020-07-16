part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NewPostNotification extends NotificationEvent {
  final Notification notification;

  const NewPostNotification({@required this.notification});

  @override
  List<Object> get props => [notification];
}

class NewFollowNotification extends NotificationEvent {
  final Notification notification;

  const NewFollowNotification({@required this.notification});

  @override
  List<Object> get props => [notification];
}

class NewReactionNotification extends NotificationEvent {
  final Notification notification;

  const NewReactionNotification({@required this.notification});

  @override
  List<Object> get props => [notification];
}

class NewCommentNotification extends NotificationEvent {
  final Notification notification;

  const NewCommentNotification({@required this.notification});

  @override
  List<Object> get props => [notification];
}
