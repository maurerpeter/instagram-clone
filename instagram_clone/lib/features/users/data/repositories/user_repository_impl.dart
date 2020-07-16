import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:instagram_clone/features/users/data/datasources/user_remote_data_source.dart';
import 'package:instagram_clone/features/users/domain/entities/user.dart';
import 'package:instagram_clone/features/users/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  UserRepositoryImpl({
    @required this.remoteDataSource,
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, List<User>>> getFollowedUsers(String username) async {
    try {
      final jwtToken = await _getJwtToken();
      final List<User> users = await remoteDataSource.getFollowedUsers(
        jwtToken: jwtToken,
        username: username,
      );
      return Right(users);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers(String username) async {
    try {
      final jwtToken = await _getJwtToken();
      final List<User> users = await remoteDataSource.getUsers(
        jwtToken: jwtToken,
        username: username,
      );
      return Right(users);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> followUser(String id) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.followUser(jwtToken: jwtToken, id: id);
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> unfollowUser(String id) async {
    try {
      final jwtToken = await _getJwtToken();
      await remoteDataSource.unfollowUser(jwtToken: jwtToken, id: id);
      return Right(unit);
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

  @override
  Future<Either<Failure, Unit>> updateProfilePicture(File picture) async {
    try {
      final jwtToken = await _getJwtToken();
      final User self = await remoteDataSource.getSelf(jwtToken: jwtToken);
      await remoteDataSource.patchSelf(
        jwtToken: jwtToken,
        id: self.id,
        profilePicture: picture,
      );
      return Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
