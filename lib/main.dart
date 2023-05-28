import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// reddit api lib
import 'reddit.dart';

/// components
import 'screens/profile/auth_handler.dart';
import 'screens/feed/feed_view.dart';
import 'screens/feed/feed_state.dart';

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
    var theme = Brightness.dark;
    return MaterialApp(
        title: 'bluejay',
        theme: ThemeData(
          useMaterial3: true,
          brightness: theme,
          colorSchemeSeed: Colors.deepPurple,
        ),
        home: MultiProvider(providers: [
          ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
          ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ], child: MainLayout()));
    // return ChangeNotifierProvider(
    //   create: (context) => MyAppState(),
    //   child: MaterialApp(
    //     title: 'Namer App',
    //     theme: ThemeData(
    //       useMaterial3: true,
    //       colorScheme: ColorScheme.fromSeed(
    //           seedColor: Colors.deepPurple, brightness: Brightness.dark),
    //     ),
    //     home: MyHomePage(),
    //   ),
    // );
  }
}

class MainLayout extends StatefulWidget {
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var appState = Provider.of<AppState>(context, listen: false);
      await appState.getAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("BlueJay"),
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
      // TODO: add button
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => setState(() {
      //     _count++;
      //   }),
      //   tooltip: 'Increment Counter',
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
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
