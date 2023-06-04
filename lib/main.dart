import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

/// reddit api lib
import 'reddit.dart';

/// components
import 'screens/profile/auth_handler.dart';
import 'screens/feed/feed_view.dart';
import 'screens/post/reddit_post.dart';
import 'components/fab_menu.dart';

/// state
import 'screens/feed/feed_state.dart';
import 'screens/post/post_state.dart';

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  try {
    await dotenv.load(fileName: '.env');
  } catch (err) {
    print(err);
    rethrow;
  }
  runApp(Bluejay());
}

class Bluejay extends StatelessWidget {
  const Bluejay({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
          ChangeNotifierProvider<AppState>(create: (_) => AppState()),
          ChangeNotifierProvider<PostState>(create: (_) => PostState()),
        ],
        child: MaterialApp.router(
          title: 'bluejay',
          theme: ThemeData(
            useMaterial3: true,
            brightness: brightness,
            colorSchemeSeed: Colors.deepPurple,
          ),
          routerConfig: _router,
        ));
  }
}

final _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => MainLayout(
      startViewIndex: 0,
    ),
  ),

  /// TODO
  GoRoute(
      path: '/login',
      builder: (context, state) => MainLayout(
            startViewIndex: 3,
          )),
  GoRoute(path: '/post', builder: (context, state) => PostLayout())
]);

class PostLayout extends StatelessWidget {
  const PostLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text('Feed'), elevation: 2),
      body: RedditPostView(
        isExpanded: true,
      ),
    ));
  }
}

class MainLayout extends StatefulWidget {
  final int startViewIndex;

  const MainLayout({Key? key, required this.startViewIndex}) : super(key: key);

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int viewIndex = 0;

  void _onViewChange(int index) {
    setState(() {
      viewIndex = index;
    });
  }

  static final List<Widget> _views = [
    RedditFeedWidget(),
    Placeholder(),
    OAuth2FlowWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _onViewChange(widget.startViewIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var appState = Provider.of<AppState>(context, listen: false);
      await appState.getAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var theme = Theme.of(context);
    var feedState = context.watch<FeedState>();

    List<String> viewTitles = [
      "${feedState.feedSort} Feed",
      "Search",
      "Profile"
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(viewTitles.elementAt(viewIndex)),
          elevation: 2,
        ),
        body: _views.elementAt(viewIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.table_rows_rounded), label: 'Feed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(appState.isAuth ? Icons.person : Icons.login),
                label: appState.isAuth ? 'Profile' : 'Log In')
          ],
          onTap: _onViewChange,
          currentIndex: viewIndex,
        ),
        floatingActionButton: FABMenu(theme: theme, feedState: feedState),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndFloat);
  }
}

class AppState extends ChangeNotifier {
  final RedditAPI _api = redditApi;
  bool isAuth = false;

  Future<void> getAuthState() async {
    isAuth = await _api.checkAuth();
    notifyListeners();
  }
}
