import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class LeftBubble extends StatelessWidget {
  final String content;
  const LeftBubble({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: Alignment.topLeft,
      nip: BubbleNip.leftTop,
      child: Text(
        content,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
