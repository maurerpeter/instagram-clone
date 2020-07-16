import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/util/http_util.dart';
import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:meta/meta.dart';

import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  /// Throws [ServerException] for all error codes.
  Future<List<PostModel>> getPosts({
    @required JwtToken jwtToken,
    @required int limit,
    @required int offset,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> createPost({
    @required JwtToken jwtToken,
    @required String description,
    @required File media,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> deletePost({@required JwtToken jwtToken, @required String id});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final String url = ConfigReader.getPostsUrl();

  PostRemoteDataSourceImpl({@required this.client});

  @override
  Future<void> createPost({
    JwtToken jwtToken,
    String description,
    File media,
  }) async {
    final String filename = media.path;
    final String fileExtenstion = filename.split('.').last;
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['authorization'] = 'Bearer ${jwtToken.token}';
    request.fields['description'] = description;
    // FIXME: proper file type checking
    if (fileExtenstion == 'jpg' || fileExtenstion == 'png') {
      request.fields['type'] = 'image';
    } else if (fileExtenstion == 'mp4') {
      request.fields['type'] = 'video';
    }
    request.files.add(await http.MultipartFile.fromPath('media', filename));
    final response = await request.send();
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }

  @override
  Future<void> deletePost({JwtToken jwtToken, String id}) async {
    final response = await client.delete(
      '$url/id',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> getPosts({
    JwtToken jwtToken,
    int limit,
    int offset,
  }) async {
    final response = await client.get(
      '$url?limit=$limit&offset=$offset&followedBy=${jwtToken.getUsername()}',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return (json.decode(response.body) as List)
          .map((rawPost) => PostModel.fromJson(rawPost))
          .toList();
    }
  }
}
