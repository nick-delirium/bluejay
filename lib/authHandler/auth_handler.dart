import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';
import '../reddit.dart';

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
      print(code);
      if (code != null) {
        try {
          var prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_code', code);
          var stored = prefs.getString('auth_code');
          print(stored);
          _redditAPI.authFinish(code);
        } catch (error) {
          print(error);
          rethrow;
        }
      }
    }
  }

  void openAuthUrl() async {
    dynamic authUrl = _redditAPI.startAuth();
    print(await canLaunchUrl(authUrl));
    try {
      launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: openAuthUrl,
          child: Text('Log In'),
        ),
      ),
    );
  }
}
