import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class JwtToken extends Equatable {
  final String token;

  const JwtToken({@required this.token});

  String getUsername() {
    final String payload = token.split('.')[1];
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    if (payloadMap is Map<String, dynamic>) {
      return payloadMap['username'] as String;
    }
    return '';
  }

  @override
  List<Object> get props => [token];
}
