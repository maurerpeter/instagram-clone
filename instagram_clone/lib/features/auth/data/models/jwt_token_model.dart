import 'package:instagram_clone/features/auth/domain/entities/jwt_token.dart';
import 'package:meta/meta.dart';

class JwtTokenModel extends JwtToken {
  const JwtTokenModel({
    @required String token,
  }) : super(token: token);

  factory JwtTokenModel.fromJson(Map<String, dynamic> json) {
    return JwtTokenModel(token: json['token'] as String);
  }
}
