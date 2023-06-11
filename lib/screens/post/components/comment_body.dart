import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_comment.dart';
import 'package:flutter/services.dart';
import 'package:bluejay/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comment_header.dart';
import 'comment_bottom.dart';

class CommentBody extends StatefulWidget {
  const CommentBody(
      {super.key, required this.comment, required this.level, this.showAll});

  final Comment comment;
  final bool? showAll;
  final int level;

  @override
  State<CommentBody> createState() => _CommentBodyState();
}

class _CommentBodyState extends State<CommentBody> {
  bool isExpanded = false;
  bool showAll = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isExpanded = widget.level < 3;
    });
  }

  toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  showAllTree() {
    setState(() {
      showAll = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var subCommentColor = rainbow();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentHeader(
          comment: widget.comment,
        ),
        GestureDetector(
          onLongPress: () {
            setState(() {
              if (showAll) {
                isExpanded = false;
                showAll = false;
              } else {
                isExpanded = !isExpanded;
              }
            });
          },
          child: Html(
            data: widget.comment.body,
            onLinkTap: (url, context, attributes, element) {
              if (url != null) {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            },
            onImageTap: (url, context, attributes, element) {
              print(url);
            },
            onImageError: (exception, stackTrace) {
              print(exception);
            },
            onCssParseError: (css, messages) {
              print("css that errored: $css");
              print("error messages:");
              for (var element in messages) {
                print(element);
              }
              return null;
            },
          ),
        ),
        CommentBottom(
          comment: widget.comment,
        ),
        if (widget.comment.replies.isNotEmpty ||
            widget.comment.hiddenReplies != null)
          Container(
            decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(color: subCommentColor, width: 2))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 0, 0),
              child: showChildren(widget.comment.replies.isNotEmpty, isExpanded,
                      showAll, widget.level)
                  ? Column(
                      children: [
                        for (var subComment in widget.comment.replies)
                          CommentBody(
                              comment: subComment, level: widget.level + 1)
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget.comment.replies.isEmpty) {
                          HapticFeedback.vibrate();
                        } else {
                          setState(() {
                            showAll = true;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '${widget.comment.hiddenReplies} skipped',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
            ),
          ),
      ],
    );
  }
}

bool showChildren(bool hasChildren, bool isExpanded, bool showAll, int level) {
  if (hasChildren) {
    if (showAll) {
      return true;
    } else {
      return isExpanded && level < 3;
    }
  }
  return false;
}
