import 'package:flutter/material.dart';
import 'package:bluejay/types/reddit_post.dart';
import 'post_selftext.dart';

class PostBody extends StatelessWidget {
  const PostBody({
    super.key,
    required this.isExpanded,
    required this.thumbnail,
    required this.postType,
    required this.selftext,
  });

  final String? selftext;
  final String? thumbnail;
  final PostType postType;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selftext != null)
            Expanded(
              child: PostSelfText(text: selftext!, isExpanded: isExpanded),
            ),
          if (thumbnail != null && showThumbNail(postType))
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 75,
                width: 75,
                child: Image.network(
                  thumbnail!,
                  semanticLabel: 'Post Thumbnail',
                  fit: BoxFit.fitHeight,
                ),
              ),
            )
        ],
      ),
    );
  }
}

bool showThumbNail(PostType postType) {
  return [PostType.link, PostType.text].contains(postType);
}
