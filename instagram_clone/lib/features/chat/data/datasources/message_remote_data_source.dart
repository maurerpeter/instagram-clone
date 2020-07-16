import 'dart:convert';

import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/util/http_util.dart';
import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/chat/data/models/message_model.dart';
import 'package:instagram_clone/features/chat/domain/entities/message.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class MessageRemoteDataSource {
  /// Throws [ServerException] for all error codes.
  Future<List<Message>> getMessages({
    @required JwtToken jwtToken,
    @required String username,
    @required int limit,
    @required int offset,
  });
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final http.Client client;
  final String url = ConfigReader.getMessagesUrl();

  MessageRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<Message>> getMessages({
    JwtToken jwtToken,
    String username,
    int limit,
    int offset,
  }) async {
    final response = await client.get(
      '$url?username=$username&limit=$limit&offset=$offset',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return (json.decode(response.body) as List)
          .map((rawMessage) => MessageModel.fromJson(rawMessage))
          .toList();
    }
  }
}
