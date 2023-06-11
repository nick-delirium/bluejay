import 'package:bluejay/reddit_library/reddit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class Rating extends StatelessWidget {
  const Rating(
      {required this.voteDir,
      required this.onDown,
      required this.onUp,
      required this.score});

  final VoteDir voteDir;
  final Function onUp;
  final Function onDown;
  final int score;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.compact();
    return (Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_drop_down,
            semanticLabel: 'Downvote',
          ),
          color: voteDir == VoteDir.down ? Colors.purple : Colors.blueGrey,
          padding: EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {
            onDown();
            HapticFeedback.vibrate();
          },
        ),
        Text(formatter.format(score)),
        IconButton(
          icon: Icon(
            Icons.arrow_drop_up,
            semanticLabel: 'Upvote',
          ),
          color: voteDir == VoteDir.up ? Colors.red : Colors.blueGrey,
          padding: EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {
            onUp();
            HapticFeedback.vibrate();
          },
        ),
      ],
    ));
  }
}
