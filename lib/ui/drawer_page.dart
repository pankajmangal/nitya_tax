import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nityaassociation/model/navigation_util.dart';
import 'package:nityaassociation/model/social_media.dart';
import 'package:nityaassociation/ui/bookmark/bookmarks.dart';
import 'package:nityaassociation/ui/profile/profile.dart';
import 'package:nityaassociation/ui/query/query_page.dart';
import 'package:nityaassociation/ui/settings/setttings.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/image_helper.dart';
import 'package:nityaassociation/utils/prefs_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final List<String> mainDrawerItem = ["Home", "Bulletin", "Events", "Query"];
  final List<String> secondaryDrawerItem = [
    'Updates',
    'Articles',
    "Videos",
    'Bookmarks'
  ];
  final List<String> options = ['My Profile', 'Settings', "Logout"];

  final List<SocialMedia> socialMedias = [
    SocialMedia(FB_ICON, "https://www.facebook.com/NiytaTaxAssoicates/",
        Color(0xff3b5998)),
    SocialMedia(
        LI_ICON,
        "https://www.linkedin.com/in/nitya-tax-associates-b6a166129/",
        Color(0xff0e76a8)),
    SocialMedia(YU_ICON, "https://www.youtube.com/NITYATaxAssociates",
        Color(0xffFF0000)),
    SocialMedia(TW_ICON, "https://twitter.com/tax_nitya", Color(0xff00AACE)),
  ];

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationModel>(context);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                  width: 196,
                  child: SvgPicture.asset(
                    LOGO,
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ScrollConfiguration(
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              children: mainDrawerItem.map((v) {
                                int index = mainDrawerItem.indexOf(v);
                                return InkWell(
                                  onTap: () {
                                    if (index > 1) {
                                      index++;
                                    }
                                    navigation.setMainIndex(index);
                                    navigation.closeDrawer();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Text(
                                      v,
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            behavior: MyBehavior(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            height: 2,
                            color: Colors.grey,
                          ),
                          ScrollConfiguration(
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              children: secondaryDrawerItem.map((v) {
                                return InkWell(
                                  onTap: () {
                                    int index = secondaryDrawerItem.indexOf(v);
                                    if (index == 3) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BookMarks()));
                                    } else {
                                      navigation.setMainIndex(0);
                                      navigation.setHomeIndex(index + 1);
                                    }

                                    navigation.closeDrawer();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Text(
                                      v,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            behavior: MyBehavior(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            height: 2,
                            color: Colors.grey,
                          ),
                          ScrollConfiguration(
                            child: ListView(
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              children: options.map((v) {
                                return InkWell(
                                  onTap: () async {
                                    int index = options.indexOf(v);
                                    switch (index) {
                                      case 0:
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Profile()));
                                        break;
                                      case 1:
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Settings()));
                                        break;
                                      case 2:
                                        //show dialog
                                        bool v = await _sureLogout(context);
                                        print(v);
                                        if (v) {
                                          //logout the user
                                        }
                                        break;
                                    }

                                    navigation.closeDrawer();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Text(
                                      v,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            behavior: MyBehavior(),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Spacer(),
                Container(
                  height: 56,
                  color: Colors.white,
                  child: Row(
                    children: socialMedias.map((e) {
                      return InkWell(
                        onTap: () {
                          _launchURL(e.url);
                        },
                        child: Container(
                          margin: EdgeInsets.all(16),
                          child: SvgPicture.asset(
                            e.image,
                            color: e.color,
                            width: 24,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _sureLogout(BuildContext context) {
    return showDialog(
          context: context,
          child: AlertDialog(
            actionsPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            title: Text('Logout?'),
            content: Text(
              "This will log you out from this device.",
              style: TextStyle(color: Colors.black54),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
              FlatButton(
                onPressed: () {
                  PrefsHelper.deleteUser();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  'OKAY',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
