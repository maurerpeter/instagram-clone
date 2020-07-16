import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../entities/jwt_token.dart';

abstract class AuthRepository {
  Future<Either<Failure, JwtToken>> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<Either<Failure, Unit>> signUpWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<Either<Failure, Unit>> deleteToken();

  Future<Either<Failure, Unit>> persistToken(String token);

  Future<Either<Failure, bool>> hasToken();

  Future<Either<Failure, JwtToken>> getToken();
}
