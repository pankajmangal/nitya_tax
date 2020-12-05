import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nityaassociation/network/api_provider.dart';
import 'package:nityaassociation/ui/login/sign_in.dart';
import 'package:nityaassociation/ui/main_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/image_helper.dart';
import 'package:nityaassociation/utils/prefs_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        statusBarIconBrightness: Brightness.light));
  }

  double position = 8;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.60;
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: SvgPicture.asset(
                LOGO,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 36,
              width: width,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Spacer(),
                      Container(
                        height: 24,
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade600),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  Positioned(
                    left: position,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final end = (width -
                            56 -
                            8); // 8 is little gap in last , 56 is the width of the kprimaryContainer

                        if (position > end - 8) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AppUtils.currentUser == null
                                      ? SignIn()
                                      : MainPage()));
                        }
                        if (position >= 8 && position < end) {
                          setState(() {
                            position += details.delta.dx;
                          });
                        }
                      },
                      child: Container(
                        width: 56,
                        height: 36,
                        color: kPrimaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Swipe to enter",
              style: TextStyle(color: Colors.black.withOpacity(0.60)),
            ),
          ],
        ),
      ),
    );
  }
}
