import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class RightBubble extends StatelessWidget {
  final String content;
  const RightBubble({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Colors.blue[600],
      child: Text(
        content,
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
