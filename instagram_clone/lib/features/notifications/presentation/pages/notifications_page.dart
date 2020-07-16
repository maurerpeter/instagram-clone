import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/notifications/domain/entities/notification.dart'
    as entities;
import 'package:instagram_clone/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:meta/meta.dart';

class NotificationsPage extends StatefulWidget {
  final NotificationBloc notificationBloc;
  const NotificationsPage({Key key, @required this.notificationBloc})
      : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<entities.Notification> notifications;

  @override
  void initState() {
    notifications = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is ReceivedNotification) {
          setState(() {
            notifications.insert(0, state.notification);
          });
        }
      },
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              child: notification.getSender().profilePictureUrl == null
                  ? const Text('No image')
                  : Image.network(notification.getSender().profilePictureUrl),
            ),
            trailing: Container(
              width: 300,
              child: Text(
                '${notification.getContent()}',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          );
        },
      ),
    );
  }
}
