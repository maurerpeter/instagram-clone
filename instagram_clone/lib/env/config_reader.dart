import 'dart:convert';

import 'package:flutter/services.dart';

abstract class ConfigReader {
  static Map<String, dynamic> _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getAuthUrl() {
    return _config['authUrl'] as String;
  }

  static String getPostsUrl() {
    return _config['postsUrl'] as String;
  }

  static String getUsersUrl() {
    return _config['usersUrl'] as String;
  }

  static String getReactionsUrl() {
    return _config['reactionsUrl'] as String;
  }

  static String getCommentsUrl() {
    return _config['commentsUrl'] as String;
  }

  static String getMessagesUrl() {
    return _config['messagesUrl'] as String;
  }

  static String getStompUrl() {
    return _config['stompUrl'] as String;
  }
}
