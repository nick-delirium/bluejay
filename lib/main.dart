import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reddit.dart';
import 'authHandler/auth_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
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
        home: MainLayout());
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(theme);
    return ChangeNotifierProvider(
      create: (context) => FeedState(),
      child: Scaffold(
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
                icon: Icon(Icons.person_2_rounded), label: 'Profile')
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
      ),
    );
  }
}

class RedditFeedWidget extends StatefulWidget {
  @override
  RedditFeedWidgetState createState() => RedditFeedWidgetState();
}

class RedditFeedWidgetState extends State<RedditFeedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var feedState = Provider.of<FeedState>(context, listen: false);
      if (feedState.data.isEmpty) {
        feedState.fetchBest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var feedState = context.watch<FeedState>();
    print(feedState.data.length);
    return Center(
      child: Stack(children: [
        RefreshIndicator(
          onRefresh: feedState.fetchBest,
          child: ListView.builder(
              itemCount: feedState.data.length,
              itemBuilder: (context, index) {
                var entry = feedState.data[index];
                return Text(entry['data']['title']);
              }),
        ),
        if (feedState.isLoading) Center(child: CircularProgressIndicator()),
      ]),
    );
  }
}

class FeedState extends ChangeNotifier {
  dynamic data = [];
  final RedditAPI _api = redditApi;
  bool isLoading = false;

  Future<void> fetchBest() async {
    final rData = await _api.getHot(30, 0);
    data = rData['data']['children'];
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void getAuth() {
    _api.startAuth();
  }
}

class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var feedState = context.watch<FeedState>();
    return Center(
      child:
          ElevatedButton(onPressed: feedState.getAuth, child: Text('Log In')),
    );
  }
}
