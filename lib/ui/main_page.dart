import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:nityaassociation/model/navigation_util.dart';
import 'package:nityaassociation/model/post.dart';
import 'package:nityaassociation/ui/app.dart';
import 'package:nityaassociation/ui/bookmark/bloc/bookmark_bloc.dart';
import 'package:nityaassociation/ui/byte/bloc/bytes_bloc.dart';
import 'package:nityaassociation/ui/dynamic_page_post.dart';
import 'package:nityaassociation/ui/event/bloc/event_bloc.dart';
import 'package:nityaassociation/ui/no_internet.dart';
import 'package:nityaassociation/ui/notifications/bloc/notification_bloc.dart';
import 'package:nityaassociation/ui/post/post_detail_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:provider/provider.dart';

import 'drawer_page.dart';
import 'home/bloc/post_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String accessToke = AppUtils.currentUser.accessToken;
    getConnectionStatus();
    PostBloc().fetchPosts(accessToke);
    ByteBloc().fetchBytes(accessToke);
    EventBloc().fetchEvents(accessToke);
    BookmarkBloc().fetchBookmarks(accessToke);
    NotificationBloc().getNotifications(accessToke);
    onNewLink();
  }

  var streamConnectionStatus;

  getConnectionStatus() async {
    streamConnectionStatus = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!

      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          hasConnection = true;
        });
      } else {
        setState(() {
          hasConnection = false;
        });
      }
    });
  }

  void onNewLink() async {
    FirebaseDynamicLinks.instance.onLink(onError: (e) {
      print(e.details);
      return null;
    }, onSuccess: (PendingDynamicLinkData d) {
      if (d.link.path == '/post') {
        print("go to post");
        String id = d.link.queryParameters['id'];
        print(id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DynamicPage(id, ContentType.POST)));
      }
      if (d.link.path == '/event') {
        print("go to event");
        String id = d.link.queryParameters['id'];
        print(id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DynamicPage(id, ContentType.EVENT)));
      }
      return null;
    });
  }

  bool hasConnection = true;



  @override
  Widget build(BuildContext context) {
    return hasConnection
        ? ChangeNotifierProvider(
            create: (BuildContext context) => NavigationModel(),
            child: Stack(
              children: <Widget>[
                DrawerPage(),
                AppBody(),
              ],
            ),
          )
        : NoInternet("Check Internet Connection");
  }
}
