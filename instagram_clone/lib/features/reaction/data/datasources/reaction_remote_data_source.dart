import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/util/http_util.dart';
import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/reaction/data/models/reaction_model.dart';
import 'package:meta/meta.dart';

abstract class ReactionRemoteDataSource {
  /// Throws [ServerException] for all error codes.
  Future<List<ReactionModel>> getReactions({
    @required JwtToken jwtToken,
    @required String postId,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> createReaction({
    @required JwtToken jwtToken,
    @required String postId,
    @required String type,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> deleteReaction({
    @required JwtToken jwtToken,
    @required String id,
  });
}

class ReactionRemoteDataSourceImpl implements ReactionRemoteDataSource {
  final http.Client client;
  final String url = ConfigReader.getReactionsUrl();

  ReactionRemoteDataSourceImpl({@required this.client});

  @override
  Future<void> createReaction({
    JwtToken jwtToken,
    String postId,
    String type,
  }) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${jwtToken.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'post': postId, 'type': type}),
    );

    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }

  @override
  Future<List<ReactionModel>> getReactions({
    JwtToken jwtToken,
    String postId,
  }) async {
    final response = await client.get(
      '$url?postId=$postId',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return (json.decode(response.body) as List)
          .map((rawReaction) => ReactionModel.fromJson(rawReaction))
          .toList();
    }
  }

  @override
  Future<void> deleteReaction({JwtToken jwtToken, String id}) async {
    final response = await client.delete(
      '$url/id',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }
}
