import 'package:dartz/dartz.dart';
import 'package:instagram_clone/core/error/exceptions.dart';
import 'package:instagram_clone/core/error/failures.dart';
import 'package:instagram_clone/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:instagram_clone/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:instagram_clone/features/auth/domain/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl({
    @required this.authRemoteDataSource,
    @required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, JwtToken>> signInWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final jwtToken = await authRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(jwtToken);
    } on ServerException {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(
      {String email, String password}) async {
    try {
      await authRemoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(unit);
    } on ServerException {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteToken() async {
    try {
      await authLocalDataSource.deleteToken();
      return right(unit);
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasToken() async {
    try {
      final bool hasToken = await authLocalDataSource.hasToken();
      return right(hasToken);
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> persistToken(String token) async {
    try {
      await authLocalDataSource.persistToken(token);
      return right(unit);
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, JwtToken>> getToken() async {
    try {
      return right(JwtToken(token: await authLocalDataSource.getToken()));
    } on CacheException {
      return left(CacheFailure());
    }
  }
}
