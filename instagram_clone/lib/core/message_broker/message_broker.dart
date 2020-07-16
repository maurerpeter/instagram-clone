import 'dart:convert';

import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/chat/domain/entities/send_message.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:meta/meta.dart';

class MessageBroker {
  StompClient stompClient;
  StompClient client;
  final AuthRepository authRepository;
  // final Function followNotificationCallback;

  MessageBroker({
    @required this.authRepository,
    // @required this.followNotificationCallback,
  }) {
    stompClient = StompClient(
      config: StompConfig(
        url: ConfigReader.getStompUrl(),
        onConnect: (StompClient client, StompFrame frame) async {
          print('Stomp connected');
          this.client = client;
        },
        stompConnectHeaders: {'user': 'guest', 'passcode': 'guest'},
      ),
    );
    stompClient.activate();
  }

  Future<void> subscribeToMessages({
    @required Function followNotificationCallback,
    @required Function postNotificationCallback,
    @required Function reactionNotificationCallback,
    @required Function commentNotificationCallback,
    @required Function chatNotificationCallback,
  }) async {
    final failureOrToken = await authRepository.getToken();
    final jwtToken = failureOrToken.fold(
      (_) => throw Exception('No local jwt token'),
      (jwtToken) => jwtToken,
    );
    client.subscribe(
      destination: '/queue/${jwtToken.getUsername()}',
      callback: (StompFrame frame) {
        final result = json.decode(frame.body);
        final type = result['type'] as String;
        //! CHECK FOR EVERY NOTIFICATION TYPE
        if (type == 'follow') {
          followNotificationCallback(result);
        } else //
        if (type == 'post') {
          postNotificationCallback(result);
        } else //
        if (type == 'reaction') {
          reactionNotificationCallback(result);
        } else //
        if (type == 'comment') {
          commentNotificationCallback(result);
        } else //
        if (type == 'chat') {
          chatNotificationCallback(result);
        }
      },
    );
  }

  Future<void> sendMessage(SendMessage message) async {
    final failureOrToken = await authRepository.getToken();
    final jwtToken = failureOrToken.fold(
      (_) => throw Exception('No local jwt token'),
      (jwtToken) => jwtToken,
    );
    client.send(
      destination: '/queue/chat-send-queue',
      body: jsonEncode({
        'from': jwtToken.getUsername(),
        'to': message.to,
        'content': message.content,
      }).toString(),
    );
  }
}
