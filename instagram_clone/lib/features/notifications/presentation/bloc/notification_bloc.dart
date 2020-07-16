import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => NotificationInitial();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is NewFollowNotification) {
      yield ReceivedNotification(notification: event.notification);
    } else //
    if (event is NewPostNotification) {
      yield ReceivedNotification(notification: event.notification);
    } else //
    if (event is NewReactionNotification) {
      yield ReceivedNotification(notification: event.notification);
    } else //
    if (event is NewCommentNotification) {
      yield ReceivedNotification(notification: event.notification);
    }
  }
}
