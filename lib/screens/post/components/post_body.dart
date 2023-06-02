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
    required this.images,
    this.postUrl,
  });

  final String? selftext;
  final String? thumbnail;
  final PostType postType;
  final bool isExpanded;
  final List<PostImage> images;
  final String? postUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          if (images.isNotEmpty)
            if (images.length == 1)
              Image.network(
                images[0].preview,
                semanticLabel: 'Post image',
                fit: BoxFit.contain,
                height: isExpanded ? null : 320,
                width: isExpanded ? MediaQuery.of(context).size.width : null,
              )
            else if (images.length > 1) //for (var image in images)
              ImageGallery(images: images, isExpanded: isExpanded),
          Row(
            crossAxisAlignment: selftext != null
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (selftext != null)
                Expanded(
                  child: PostSelfText(text: selftext!, isExpanded: isExpanded),
                ),
              if (thumbnail != null && showThumbNail(postType))
                Expanded(
                  flex: 1,
                  child: Padding(
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
                  ),
                ),
              if (postUrl != null && postType == PostType.link)
                Expanded(
                  flex: 3,
                  child: Text(
                    '$postUrl',
                    softWrap: true,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    super.key,
    required this.images,
    required this.isExpanded,
  });

  final List<PostImage> images;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: images.length,
        pageSnapping: true,
        itemBuilder: (context, pagePosition) {
          return Container(
              margin: EdgeInsets.all(10),
              child: Image.network(
                images[pagePosition].preview,
                semanticLabel: 'Post image',
                fit: BoxFit.contain,
                height: isExpanded ? null : 320,
                width: isExpanded ? MediaQuery.of(context).size.width : null,
              ));
        });
  }
}

bool showThumbNail(PostType postType) {
  return [PostType.link, PostType.text].contains(postType);
}
