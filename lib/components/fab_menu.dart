import 'package:flutter/material.dart';

/// reddit api lib
import 'package:bluejay/reddit.dart';

/// state
import 'package:bluejay/screens/feed/feed_state.dart';

class FABMenu extends StatelessWidget {
  const FABMenu({
    super.key,
    required this.theme,
    required this.feedState,
  });

  final ThemeData theme;
  final FeedState feedState;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.all(Radius.circular(99))),
        child: Icon(
          Icons.settings,
          semanticLabel: "Feed actions",
        ),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<FABACtion>>[
        const PopupMenuItem<FABACtion>(
          value: FABACtion.sortHot,
          child: Text('Sort by hot'),
        ),
        const PopupMenuItem<FABACtion>(
          value: FABACtion.sortTop,
          child: Text('Sort by top'),
        ),
      ],
      onSelected: (value) {
        if (value == FABACtion.sortTop) {
          feedState.setSort(Sort.top);
          feedState.fetchHome();
        } else {
          feedState.setSort(Sort.hot);
          feedState.fetchHome();
        }
      },
    );
  }
}

enum FABACtion {
  sortHot,
  sortTop,
  hideSeen,
}
