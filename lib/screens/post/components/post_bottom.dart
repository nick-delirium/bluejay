import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bluejay/types/reddit_post.dart';

class PostBottom extends StatelessWidget {
  const PostBottom({
    super.key,
    required this.isExpanded,
    required this.score,
    required this.upvoteRatio,
    required this.postType,
    required this.postUrl,
    required this.mediaUrl,
    this.commentsAmount,
  });

  final int score;
  final bool isExpanded;
  final String upvoteRatio;
  final PostType postType;
  final String postUrl;
  final String mediaUrl;
  final int? commentsAmount;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var formatter = NumberFormat.compact();

    bool isWithMedia = "https://www.reddit.com$postUrl" != mediaUrl;
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 2, color: theme.colorScheme.onSurface))),
      child: Row(
        children: [
          if (isWithMedia)
            PopupMenuButton(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              icon: Icon(
                Icons.share,
                semanticLabel: "Share post",
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ShareType>>[
                const PopupMenuItem<ShareType>(
                  value: ShareType.full,
                  child: Text('Share post link'),
                ),
                const PopupMenuItem<ShareType>(
                  value: ShareType.media,
                  child: Text('Share post media'),
                ),
              ],
              onSelected: (value) {
                if (value == ShareType.full) {
                  Share.share("https://reddit.com$postUrl");
                } else {
                  Share.share(mediaUrl);
                }
              },
            )
          else
            IconButton(
                onPressed: () {
                  Share.share("https://www.reddit.com$postUrl");
                },
                icon: Icon(
                  Icons.share,
                  semanticLabel: 'Share post',
                )),
          if (commentsAmount != null)
            Icon(
              Icons.comment,
              semanticLabel: 'comments amount',
            ),
          if (commentsAmount != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(commentsAmount.toString()),
            ),
          Spacer(),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.thumb_up_alt,
                color: theme.colorScheme.primary,
                semanticLabel: 'Upvote ratio',
                size: 18,
              ),
            ),
          if (isExpanded) Text(upvoteRatio, style: TextStyle(fontSize: 14)),
          IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              semanticLabel: 'Downvote',
            ),
            padding: EdgeInsets.all(0),
            iconSize: 28,
            onPressed: () {
              print('down');
              HapticFeedback.vibrate();
            },
          ),
          Text(formatter.format(score)),
          IconButton(
            icon: Icon(
              Icons.arrow_drop_up,
              semanticLabel: 'Upvote',
            ),
            padding: EdgeInsets.all(0),
            iconSize: 28,
            onPressed: () {
              print('up');
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
    );
  }
}

enum ShareType { full, media }
