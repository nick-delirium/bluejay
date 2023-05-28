import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:bluejay/reddit.dart';

class OAuth2FlowWidget extends StatefulWidget {
  @override
  OAuth2FlowWidgetState createState() => OAuth2FlowWidgetState();
}

class OAuth2FlowWidgetState extends State<OAuth2FlowWidget> {
  StreamSubscription? _sub;
  final RedditAPI _redditAPI = redditApi;

  @override
  void initState() {
    super.initState();
    _sub = uriLinkStream.listen((Uri? uri) {
      handleDeepLink(uri);
    });
    _redditAPI.checkAuth();
  }

  @override
  void dispose() {
    super.dispose();
    _sub?.cancel();
  }

  void handleDeepLink(Uri? uri) async {
    if (uri != null) {
      // Extract the authorization code from the deep link URL
      String? code = uri.queryParameters['code'];
      if (code != null) {
        try {
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_code', code);
          _redditAPI.authFinish(code);
        } catch (error) {
          rethrow;
        }
      }
    }
  }

  void openAuthUrl() async {
    dynamic authUrl = _redditAPI.startAuth();
    try {
      launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } catch (error) {
      print('Error getting url: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This link will open Reddit'),
            Text('where you can approve this app'),
            Padding(padding: const EdgeInsets.all(10.0)),
            ElevatedButton(
              onPressed: openAuthUrl,
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
