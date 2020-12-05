import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nityaassociation/ui/query/query_page.dart';
import 'package:nityaassociation/utils/image_helper.dart';

class FeedThankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                SvgPicture.asset(
                  LOGO,
                  height: 196,
                ),
                SizedBox(
                  height: 36,
                ),
                Text(
                  "Thank you for your feedback! ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),
                SvgPicture.asset(
                  THUMBS_UP,
                  height: 124,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
