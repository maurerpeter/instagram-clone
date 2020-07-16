part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class ReceivedNotification extends NotificationState {
  final Notification notification;

  const ReceivedNotification({@required this.notification});

  @override
  List<Object> get props => [notification];
}
