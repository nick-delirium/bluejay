import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';

class PostSelfText extends StatelessWidget {
  const PostSelfText({
    super.key,
    required this.text,
    required this.isExpanded,
  });

  final String text;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    String safeText = isExpanded ? text : text.split('\n')[0];

    return Html(
      data: safeText,
      onLinkTap: (url, context, attributes, element) {
        print(url);
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
      style: {
        'div': isExpanded
            ? Style(fontWeight: FontWeight.w200)
            : Style(
                maxLines: 3,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w200),
      },
    );
  }
}
