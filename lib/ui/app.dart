import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nityaassociation/model/bottom_nav_item.dart';
import 'package:nityaassociation/model/navigation_util.dart';
import 'package:nityaassociation/ui/byte/bytes.dart';
import 'package:nityaassociation/ui/event/events.dart';
import 'package:nityaassociation/ui/home/home_page.dart';
import 'package:nityaassociation/ui/notifications/notifications.dart';
import 'package:nityaassociation/ui/query/query_page.dart';
import 'package:nityaassociation/ui/search/search_page.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/image_helper.dart';
import 'package:provider/provider.dart';

import 'dynamic_page_post.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final List<BottomNavItem> _bottomBar = [
    BottomNavItem('Home', HOME_ICON),
    BottomNavItem('Bulletin', BULLETIN),
    BottomNavItem('Search', SEARCH_ICON),
    BottomNavItem('Events', EVENT_ICON),
    BottomNavItem('Query', QUERY_ICON),
  ];

  final List<Widget> _bottomBody = [
    HomePage(),
    BytesPage(),
    SearchPage(),
    Events(),
    QueryPage()
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deeplink = data?.link;
    print(deeplink);

    if (deeplink != null) {
      if (deeplink.path == '/post') {
        String id = deeplink.queryParameters['id'];
        print(id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DynamicPage(id, ContentType.POST)));
      }
      if (deeplink.path == '/event') {
        String id = deeplink.queryParameters['id'];
        print(id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DynamicPage(id, ContentType.EVENT)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationModel>(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(navigation.xOffset, 0, 0),
      child: Scaffold(
          body: AbsorbPointer(
            child: _bottomBody[navigation.bottomIndex],
            absorbing: navigation.isDrawerOpen,
          ),
          appBar: AppBar(
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: kPrimaryColor,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigation.isDrawerOpen
                      ? navigation.closeDrawer()
                      : navigation.openDrawer();
                },
              ),
              centerTitle: true,
              title: Text(
                "NITYA Tax Associates",
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationPage()));
                    })
              ]),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                navigation.setMainIndex(index);
              },
              currentIndex: navigation.bottomIndex,
              unselectedFontSize: 12,
              selectedFontSize: 12,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: kPrimaryColor,
              items: _bottomBar.map((e) {
                return BottomNavigationBarItem(
                    icon: Container(
                      padding: EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        e.icon,
                        color: _bottomBar.indexOf(e) == navigation.bottomIndex
                            ? kPrimaryColor
                            : Colors.grey,
                        fit: BoxFit.fill,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    title: Text(e.title));
              }).toList())),
      duration: Duration(milliseconds: 200),
    );
  }
}
