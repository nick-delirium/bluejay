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
            ImageMedia(
              images: images,
              isExpanded: isExpanded,
            ),
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

class ImageMedia extends StatelessWidget {
  const ImageMedia({super.key, required this.images, required this.isExpanded});

  final List<PostImage> images;
  final bool isExpanded;

  @override
  Widget build(context) {
    if (images.length == 1) {
      return (Image.network(
        images[0].preview,
        semanticLabel: 'Post image',
        fit: BoxFit.contain,
        height: isExpanded ? null : 320,
        width: isExpanded ? MediaQuery.of(context).size.width : null,
      ));
    } else {
      return SizedBox(
        height: 420,
        width: MediaQuery.of(context).size.width - 10,
        child: (ImageGallery(images: images, isExpanded: isExpanded)),
      );
    }
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
          return Stack(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Image.network(
                    images.elementAt(pagePosition).preview,
                    semanticLabel: 'Post image',
                    fit: BoxFit.contain,
                    height: isExpanded ? null : 420,
                    width:
                        isExpanded ? MediaQuery.of(context).size.width : null,
                  )),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white60),
                      padding: EdgeInsets.all(4),
                      child: Text("${pagePosition + 1}/${images.length}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600))))
            ],
          );
        });
  }
}

bool showThumbNail(PostType postType) {
  return [PostType.link, PostType.text].contains(postType);
}
