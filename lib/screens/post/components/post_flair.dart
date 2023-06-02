import 'package:flutter/material.dart';

class PostFlair extends StatelessWidget {
  const PostFlair({
    super.key,
    required this.flairColor,
    required this.linkFlairText,
  });

  final Color flairColor;
  final String? linkFlairText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: flairColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        child: Text(
          linkFlairText!,
          style: TextStyle(
              color: flairColor.computeLuminance() > 0.4
                  ? Colors.black
                  : Colors.white),
        ),
      ),
    );
  }
}
