import 'dart:convert';

import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/util/http_util.dart';
import 'package:instagram_clone/env/config_reader.dart';
import 'package:instagram_clone/features/auth/data/models/jwt_token_model.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  /// Throws [ServerException] for all error codes.
  Future<JwtToken> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  /// Throws [ServerException] for all error codes.
  Future<void> signUpWithEmailAndPassword({
    @required String email,
    @required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String serverUrl = ConfigReader.getAuthUrl();

  AuthRemoteDataSourceImpl({@required this.client});

  @override
  Future<JwtTokenModel> signInWithEmailAndPassword(
      {String email, String password}) async {
    final response = await client.post(
      '$serverUrl/login',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    } else {
      return JwtTokenModel.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(
      {String email, String password}) async {
    final response = await client.post(
      '$serverUrl/signup',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (!HttpUtil.isOkStatus(response.statusCode)) {
      throw ServerException();
    }
  }
}
