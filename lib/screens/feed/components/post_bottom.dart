import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.compact();
    return Row(
      children: [
        Text(
          "by ",
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
        ),
        Text('u/${post.author}'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.arrow_drop_up),
          padding: EdgeInsets.all(0),
          iconSize: 28,
          enableFeedback: true,
          onPressed: () {
            print('up');
            HapticFeedback.lightImpact();
          },
        ),
        Text(formatter.format(post.score)),
        IconButton(
          icon: Icon(Icons.arrow_drop_down),
          padding: EdgeInsets.all(0),
          iconSize: 28,
          enableFeedback: true,
          onPressed: () {
            print('down');
            HapticFeedback.vibrate();
          },
        ),
      ],
    );
  }
}
