import 'package:instagram_clone/features/users/domain/entities/partial_user.dart';

abstract class Notification {
  PartialUser getSender();
  String getContent();
}
