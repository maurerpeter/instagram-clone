import 'dart:convert';
import 'dart:io';

import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/util/http_util.dart';
import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/users/data/models/user_model.dart';
import 'package:instagram_clone/features/users/domain/entities/user.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  /// Throws [ServerException] for all error codes.
  Future<List<User>> getUsers({
    @required JwtToken jwtToken,
    @required String username,
  });

  /// Throws [ServerException] for all error codes.
  Future<User> getSelf({@required JwtToken jwtToken});

  /// Throws [ServerException] for all error codes.
  Future<void> patchSelf({
    @required JwtToken jwtToken,
    @required String id,
    @required File profilePicture,
  });

  /// Throws [ServerException] for all error codes.
  Future<List<User>> getFollowedUsers({
    @required JwtToken jwtToken,
    @required String username,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> followUser({@required JwtToken jwtToken, @required String id});

  /// Throws [ServerException] for all error codes.
  Future<void> unfollowUser({@required JwtToken jwtToken, @required String id});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String url = ConfigReader.getUsersUrl();

  UserRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<User>> getFollowedUsers({
    JwtToken jwtToken,
    String username,
  }) async {
    final response = await client.get(
      '$url?followedBy=${jwtToken.getUsername()}&username=$username',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return (json.decode(response.body) as List)
          .map((rawUser) => UserModel.fromJson(rawUser))
          .toList();
    }
  }

  @override
  Future<List<User>> getUsers({
    JwtToken jwtToken,
    String username,
  }) async {
    final response = await client.get(
      '$url?&username=$username&excludeSelf=true',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return (json.decode(response.body) as List)
          .map((rawUser) => UserModel.fromJson(rawUser))
          .toList();
    }
  }

  @override
  Future<void> followUser({JwtToken jwtToken, String id}) async {
    final response = await client.patch(
      '$url/$id/follow',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }

  @override
  Future<void> unfollowUser({JwtToken jwtToken, String id}) async {
    final response = await client.patch(
      '$url/$id/unfollow',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }

  @override
  Future<User> getSelf({JwtToken jwtToken}) async {
    final String username = jwtToken.getUsername();
    final response = await client.get(
      '$url?&username=$username&excludeSelf=false',
      headers: {'Authorization': 'Bearer ${jwtToken.token}'},
    );
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return (json.decode(response.body) as List)
          .map((rawUser) => UserModel.fromJson(rawUser))
          .toList()
          .firstWhere(
        (userModel) {
          return userModel.username == username;
        },
        orElse: () => null,
      );
    }
  }

  @override
  Future<void> patchSelf({
    JwtToken jwtToken,
    String id,
    File profilePicture,
  }) async {
    final String filename = profilePicture.path;
    final request = http.MultipartRequest('PATCH', Uri.parse('$url/$id'));
    request.headers['authorization'] = 'Bearer ${jwtToken.token}';
    request.files.add(await http.MultipartFile.fromPath('media', filename));
    final response = await request.send();
    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }
}
