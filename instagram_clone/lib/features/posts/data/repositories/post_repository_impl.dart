import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasrouces/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  PostRepositoryImpl({
    @required this.remoteDataSource,
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, Unit>> createPost({
    String description,
    File media,
  }) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.createPost(
        jwtToken: jwtToken,
        description: description,
        media: media,
      );
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String id) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.deletePost(jwtToken: jwtToken, id: id);
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts({int limit, int offset}) async {
    try {
      final jwtToken = await _getJwtToken();
      final List<Post> posts = await remoteDataSource.getPosts(
        jwtToken: jwtToken,
        limit: limit,
        offset: offset,
      );
      return Right(posts);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  /// Throws [ServerException] when no token is found
  Future<JwtToken> _getJwtToken() async {
    final failureOrToken = await authRepository.getToken();
    final jwtToken = failureOrToken.fold(
      (_) {
        throw ServerException();
      },
      (token) => token,
    );
    return jwtToken;
  }
}
