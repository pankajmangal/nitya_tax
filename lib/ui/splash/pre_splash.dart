import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nityaassociation/network/api_provider.dart';
import 'package:nityaassociation/ui/splash/splash_screen.dart';
import 'package:nityaassociation/utils/app_utils.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/image_helper.dart';
import 'package:nityaassociation/utils/prefs_helper.dart';

class PreSplash extends StatefulWidget {
  @override
  _PreSplashState createState() => _PreSplashState();
}

class _PreSplashState extends State<PreSplash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        statusBarIconBrightness: Brightness.light));
    AppUtils();
    checkUser();
  }

  checkUser() async {
    String token = await PrefsHelper.getLoggedUser();
    if (token != null) {
      ApiProvider apiProvider = ApiProvider();
      await apiProvider.fetchUser(token).then((value) {
        AppUtils.currentUser = value;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SplashScreen()));
      }).catchError((error) {
        AppUtils.showErrorPage(error.type, context);
      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SplashScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.60;
    return Scaffold(
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
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
