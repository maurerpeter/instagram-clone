import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/util/http_util.dart';
import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/comment/data/models/comment_model.dart';
import 'package:meta/meta.dart';

abstract class CommentRemoteDataSource {
  /// Throws [ServerException] for all error codes.
  Future<List<CommentModel>> getComments({
    @required JwtToken jwtToken,
    @required String postId,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> createComment({
    @required JwtToken jwtToken,
    @required String postId,
    @required String content,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> deleteComment({
    @required JwtToken jwtToken,
    @required String id,
  });
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final http.Client client;
  final String url = ConfigReader.getCommentsUrl();

  CommentRemoteDataSourceImpl({@required this.client});

  @override
  Future<void> createComment({
    JwtToken jwtToken,
    String postId,
    String content,
  }) async {
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer ${jwtToken.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'post': postId, 'content': content}),
    );

    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }

  @override
  Future<List<CommentModel>> getComments({
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
          .map((rawComment) => CommentModel.fromJson(rawComment))
          .toList();
    }
  }

  @override
  Future<void> deleteComment({JwtToken jwtToken, String id}) async {
    final response = await client.delete(
      '$url/id',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }
}
